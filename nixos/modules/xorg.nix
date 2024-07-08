{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    excludePackages = with pkgs; [ xterm ];
    displayManager.startx.enable = true;
  };
}
