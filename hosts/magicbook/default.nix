{ config, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules
      ./packages.nix
    ];


  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "24.05"; # Did you read the comment?
}
