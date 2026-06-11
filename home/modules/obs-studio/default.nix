{
  config,
  lib,
  pkgs,
  isLinux,
  ...
}: let
  cfg = config.module.obs-studio;
  inherit (lib) mkEnableOption mkIf optionals;
in {
  options.module.obs-studio = {
    enable = mkEnableOption "Enable obs-studio module";
  };

  config = mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins;
        optionals isLinux [
          obs-pipewire-audio-capture
        ];
    };

    xdg.configFile."obs-studio/scripts/notify.lua".text = ''
      local obs = obslua

      local PROP_TITLE = "OBS Studio"

      local PROP_RECORD_START_MSG = "Запись началась"
      local PROP_RECORD_STOP_MSG = "Запись завершена"
      local PROP_REPLAY_START_MSG = "Повтор включён"
      local PROP_REPLAY_STOP_MSG = "Повтор выключён"
      local PROP_REPLAY_SAVED_MSG = "Повтор сохранён"

      local function send_notification(title, message)
          local function shq(s)
              return "'''" .. s:gsub("'", "''\\''''") .. "'''"
          end
          os.execute("notify-send --icon=com.obsproject.Studio " .. shq(title) .. " " .. shq(message))
      end

      local function on_event(event)
          if event == obs.OBS_FRONTEND_EVENT_RECORDING_STARTED then
              send_notification(PROP_TITLE, PROP_RECORD_START_MSG)
              obs.script_log(obs.LOG_INFO, "Recording started - notification sent")
          elseif event == obs.OBS_FRONTEND_EVENT_RECORDING_STOPPED then
              send_notification(PROP_TITLE, PROP_RECORD_STOP_MSG)
              obs.script_log(obs.LOG_INFO, "Recording stopped - notification sent")
          elseif event == obs.OBS_FRONTEND_EVENT_REPLAY_BUFFER_STARTED then
              send_notification(PROP_TITLE, PROP_REPLAY_START_MSG)
              obs.script_log(obs.LOG_INFO, "Replay buffer started - notification sent")
          elseif event == obs.OBS_FRONTEND_EVENT_REPLAY_BUFFER_STOPPED then
              send_notification(PROP_TITLE, PROP_REPLAY_STOP_MSG)
              obs.script_log(obs.LOG_INFO, "Replay buffer stopped - notification sent")
          elseif event == obs.OBS_FRONTEND_EVENT_REPLAY_BUFFER_SAVED then
              send_notification(PROP_TITLE, PROP_REPLAY_SAVED_MSG)
              obs.script_log(obs.LOG_INFO, "Replay buffer saved - notification sent")
          end
      end

      ---@diagnostic disable: lowercase-global
      function script_load()
          obs.obs_frontend_add_event_callback(on_event)
      end

      function script_save() end
      ---@diagnostic enable: lowercase-global
    '';
  };
}
