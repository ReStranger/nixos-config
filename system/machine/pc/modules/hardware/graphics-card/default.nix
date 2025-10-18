{
  pkgs,
  ...
}:
{
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa
        mesa.opencl
      ];
    };
    amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
    };
  };
  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
  };
  services.xserver.videoDrivers = [ "amdgpu" ];
}
