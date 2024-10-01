{ lib, ... }:
{
  networking = {
    hostName = "magicbook";
    networkmanager.enable = true;
    firewall.enable = false;
    useDHCP = lib.mkDefault true;
  };
}
