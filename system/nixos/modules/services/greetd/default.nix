{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.module.services.greetd;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
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
    };
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command =
            if cfg.frontend == "tui" then
              "${pkgs.tuigreet}/bin/tuigreet --sessions ${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session"
            else
              "${pkgs.greetd}/bin/agreety --cmd $SHELL";
          user = "greeter";
        };
      };
    };
  };
}
