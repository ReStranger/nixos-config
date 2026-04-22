{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.module.showmethekey;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.showmethekey = {
    enable = mkEnableOption "Enable showmethekey module";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.showmethekey ];
    wayland.windowManager.hyprland.settings.windowrule = [
      {
        name = "floating-show-key";
        "match:class" = "one.alynx.showmethekey";
        "match:initial_title" = "Floating Window - Show Me The Key";
        float = "on";
        pin = "on";
        size = "900 60";
        move = "500 1000";
        border_size = 0;
        no_anim = "on";
        no_blur = "on";
        no_dim = "on";
        no_focus = "on";
        no_follow_mouse = "on";
        no_initial_focus = "on";
        no_shadow = "on";
      }
    ];
  };
}
