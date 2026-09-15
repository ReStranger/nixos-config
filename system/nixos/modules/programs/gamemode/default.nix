{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.module.programs.gamemode;
  inherit (lib) mkEnableOption mkIf;
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
          start = "${pkgs.libnotify}/bin/notify-send -send -a 'Gamemode' 'Optimizations activated'";
          end = "${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations deactivated'";
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
