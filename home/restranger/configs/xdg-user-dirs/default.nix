{ config, ... }:
{
  home.packages = with pkgs; [
    xdg-user-dirs
  ];

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/";
    publicShare = "${config.home.homeDirectory}/";
  };
}
