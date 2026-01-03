{
  config,
  lib,
  ...
}:
let
  cfg = config.module.hyprland.styles.round;
  inherit (lib) mkEnableOption mkIf;
in
{
  options = {
    module.hyprland.styles.round.enable = mkEnableOption "Enable round style in Hyprland";
  };
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
        };
        decoration = {
          rounding = 15;
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
