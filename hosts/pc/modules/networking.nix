{ lib, ... }:
{
  networking = {
    hostName = "pc";
    networkmanager.enable = true;
    firewall.enable = false;
    useDHCP = lib.mkDefault true;
  };
}
