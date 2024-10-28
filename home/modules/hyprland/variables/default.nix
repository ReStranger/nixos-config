{ config
, lib
, hostname
, ...
}:

# TODO: do this more elegantly

with lib;

let
  cfg = config.module.hyprland.variables;

  sessionVariables = 
    if hostname == "pc" then
    {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";

      _JAVA_AWT_WM_NONREPARENTING = 1;
      GDK_BACKEND = "wayland,x11";
      SDL_VIDEODRIVER = "wayland,x11,windows";
      CLUTTER_BACKEND = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      DESKTOPINTEGRATION = "1";
      MANGOHUD = "1";

      MOZ_ENABLE_WAYLAND = "1";
      MOZ_DISABLE_RDD_SANDBOX = "1";

      QT_AUTO_SCREEN_SCALE_FACTOR = "1 ";
      QT_QPA_PLATFORM = "wayland;xcb ";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1 ";
      QT_QPA_PLATFORMTHEME = "gtk";

      XCURSOR_SIZE = "24";
      HYPRCURSOR_SIZE = "24";

      NIXOS_OZONE_WL = "0";
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";
      __GL_VRR_ALLOWED = 0;

      EGL_PLATFORM = "wayland";
      __EGL_VENDOR_LIBRARY_FILENAMES = "${config.boot.kernelPackages.nvidiaPackages.stable}/share/glvnd/egl_vendor.d/10_nvidia.json";
    }
    else 
    {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";

      _JAVA_AWT_WM_NONREPARENTING = 1;
      GDK_BACKEND = "wayland,x11";
      SDL_VIDEODRIVER = "wayland,x11,windows";
      CLUTTER_BACKEND = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      DESKTOPINTEGRATION = "1";
      MANGOHUD = "1";

      MOZ_ENABLE_WAYLAND = "1";
      MOZ_DISABLE_RDD_SANDBOX = "1";

      QT_AUTO_SCREEN_SCALE_FACTOR = "1 ";
      QT_QPA_PLATFORM = "wayland;xcb ";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1 ";
      QT_QPA_PLATFORMTHEME = "gtk";

      XCURSOR_SIZE = "24";
      HYPRCURSOR_SIZE = "24";

      NIXOS_OZONE_WL = "1";
    };
in {
  options = {
    module.hyprland.variables.enable = mkEnableOption "Enables variables in Hyprland";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = sessionVariables;
  };
}
