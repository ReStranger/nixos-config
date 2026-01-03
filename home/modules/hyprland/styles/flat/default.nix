{
  config,
  lib,
  ...
}:
let
  cfg = config.module.hyprland.styles.flat;
  inherit (lib) mkEnableOption mkIf;
in
{
  options = {
    module.hyprland.styles.flat.enable = mkEnableOption "Enable flat style in Hyprland";
  };
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        general = {
          gaps_in = 2;
          gaps_out = 5;
          border_size = 2;
        };
        decoration = {
          rounding = 0;
          shadow = {
            enabled = true;
            range = 30;
            offset = "2 3";
            render_power = 3;
          };
        };
      };
    };
  };
}
