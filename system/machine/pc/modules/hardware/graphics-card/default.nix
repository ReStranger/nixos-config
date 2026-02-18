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
        mesa.opencl
      ];
    };
    amdgpu = {
      initrd.enable = true;
    };
  };
  services.xserver.videoDrivers = [ "amdgpu" ];

  environment = {
    systemPackages = with pkgs; [ nvtopPackages.amd ];
    variables = {
      RUSTICL_ENABLE = "radeonsi";
    };
  };
}
