{ config, ... }:
{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/";
    publicShare = "${config.home.homeDirectory}/";
  };
}
