{ lib, ... }:
{
  networking.hostName = "magicbook";
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;
}
