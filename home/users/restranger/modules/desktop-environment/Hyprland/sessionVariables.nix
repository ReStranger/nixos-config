{ config, osConfig, ... }:
{
  home.sessionVariables =
  if ( osConfig != null && osConfig.networking.hostName == "pc") then
    {
      NIXOS_OZONE_WL = "0";
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";
      __GL_VRR_ALLOWED = 0;

      EGL_PLATFORM = "wayland";
      # __EGL_VENDOR_LIBRARY_FILENAMES = "${config.boot.kernelPackages.nvidiaPackages.beta}/share/glvnd/egl_vendor.d/10_nvidia.json";
    }
  else
    {
      NIXOS_OZONE_WL = "1";
    };
}
