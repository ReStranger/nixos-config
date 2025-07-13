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
        amdvlk
        mesa
        mesa.opencl
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };
    amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
      amdvlk = {
        enable = true;
        support32Bit.enable = true;
      };
    };
  };
  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
  };
  services.xserver.videoDrivers = [ "amdgpu" ];
}
