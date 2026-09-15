{
  lib,
  pkgs,
  config,
  username,
  ...
}: let
  cfg = config.module.programs.gamemode;
  inherit (lib) mkEnableOption mkIf getExe';
in {
  options.module.programs.gamemode = {
    enable = mkEnableOption "Enable gamemode";
  };

  config = mkIf cfg.enable {
    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        custom = {
          start = "${getExe' pkgs.libnotify "notify-send"} -send -a 'Gamemode' 'Optimizations activated'";
          end = "${getExe' pkgs.libnotify "notify-send"} -a 'Gamemode' 'Optimizations deactivated'";
        };
      };
    };

    users.users.${username}.extraGroups = ["gamemode"];

    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if ((action.id == "com.feralinteractive.GameMode.governor-helper" ||
             action.id == "com.feralinteractive.GameMode.cpu-helper" ||
             action.id == "com.feralinteractive.GameMode.gpu-helper" ||
             action.id == "com.feralinteractive.GameMode.procsys-helper") &&
            subject.isInGroup("gamemode")) {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
