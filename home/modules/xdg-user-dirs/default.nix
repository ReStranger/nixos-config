{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.module.xdg-user-dirs;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.xdg-user-dirs = {
    enable = mkEnableOption "Enable xdg-user-dirs module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      xdg-user-dirs
    ];

    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/";
      publicShare = "${config.home.homeDirectory}/";
    };
  };
}
