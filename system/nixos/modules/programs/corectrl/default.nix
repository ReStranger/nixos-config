{
  lib,
  config,
  pkgs,
  username,
  ...
}: let
  cfg = config.module.programs.corectrl;
  inherit
    (lib)
    mkEnableOption
    mkIf
    getExe'
    ;
in {
  options.module.programs.corectrl.enable = mkEnableOption "Enable corectrl";

  config = mkIf cfg.enable {
    programs.corectrl.enable = true;

    systemd.user.services.corectrl = {
      description = "corectrl (system tray)";
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${getExe' pkgs.corectrl "corectrl"} --minimize-systray";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    users.users.${username}.extraGroups = ["corectrl"];
  };
}
