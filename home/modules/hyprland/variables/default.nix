{
  config,
  lib,
  ...
}:

let
  cfg = config.module.hyprland.variables;
  inherit (lib) mkEnableOption mkIf mkForce;

  commonSessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";

    _JAVA_AWT_WM_NONREPARENTING = 1;
    GDK_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    DESKTOPINTEGRATION = "1";
    MANGOHUD = "1";

    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";

    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = mkForce "gtk3";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    GTK_USE_PORTAL = "1";

    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
  };

  hostSpecificVariables = {
    NIXOS_OZONE_WL = "1";
  };

  sessionVariables = commonSessionVariables // hostSpecificVariables;

in
{
  options = {
    module.hyprland.variables.enable = mkEnableOption "Enable variables in Hyprland";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = sessionVariables;
  };
}
