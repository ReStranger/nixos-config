{
  pkgs,
  ...
}:
{
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
    };
  };
  services.xserver.videoDrivers = [ "amdgpu" ];

  environment = {
    systemPackages = with pkgs; [ nvtopPackages.amd ];
    variables = {
      ROC_ENABLE_PRE_VEGA = 1;
    };
  };
}
