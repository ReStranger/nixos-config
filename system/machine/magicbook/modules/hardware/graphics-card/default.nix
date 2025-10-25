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
        rocmPackages.clr.icd
      ];
    };
    amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
    };
  };
  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.systemPackages = with pkgs; [ nvtopPackages.amd ];
}
