{ lib
, pkgs
, config
, username
, ...
}:

with lib;

let
  cfg = config.module.services.greetd;
in
{
  options = {
    module.services.greetd = {
      enable = mkEnableOption "Enable Greetd login manager";
      frontend = mkOption {
        type = types.enum [
          "agreety"
          "tui"
        ];
        default = "agreety";
        description = ''
          Select default frontend of greetd
        '';
      };
      autologin = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable autologin
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = (
            if cfg.frontend == "tui" then
              "${pkgs.greetd.tuigreet}/bin/tuigreet --sessions ${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session"
            else
              "${pkgs.greetd}/bin/agreety --cmd $SHELL"
          );
          user = "greeter";
        };
        initial_session = mkIf cfg.autologin {
          command = (
            if wm == "hyprland" then
              "${pkgs.hyprland}/bin/hyprland"
            else
              "${pkgs.greetd}/bin/agreety --cmd $SHELL"
          );
          user = "${username}";
        };
      };
    };
  };
}
