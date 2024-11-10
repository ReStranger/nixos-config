{ config
, pkgs
, ...
}:
{
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      cudaPackages.cudatoolkit
    ];
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {

    modesetting.enable = true;
    powerManagement.enable = true;

    powerManagement.finegrained = false;

    open = false;
    nvidiaSettings = false;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
