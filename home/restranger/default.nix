{ config, pkgs, ... }: {
  home = {
    username = "restranger";
    homeDirectory = "/home/restranger";
    stateVersion = "24.05";
  };

  imports = [
    ./modules
    ./configs
    ./packages.nix
  ];
}
