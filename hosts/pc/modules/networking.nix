{ lib, ... }:
{
  networking.hostName = "pc";
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;
}
