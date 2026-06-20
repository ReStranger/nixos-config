{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  cfg = config.module.hyprland-qt-support;
  inherit (lib) mkEnableOption mkIf mkForce;
in {
  options.module.hyprland-qt-support = {
    enable = mkEnableOption "Enable hyprland-qt-support module";
  };

  config = mkIf cfg.enable {
    home = {
      packages = [
        inputs.hyprland-qt-support.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
      sessionVariables = {
        QT_STYLE_OVERRIDE = mkForce "";
        QT_QUICK_CONTROLS_STYLE = "org.hyprland.style";
      };
    };
    xdg.configFile."hypr/application-style.conf".text = ''
      roundness = 2
      border_width = 1
      reduce_motion = false
    '';
  };
}
