{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [
      xterm
    ];
  };
}
