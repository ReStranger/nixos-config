{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.module.dolphin;
  inherit (lib) mkEnableOption mkIf;
in {
  options.module.dolphin = {
    enable = mkEnableOption "Enable dolphin module";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        kdePackages.dolphin
        kdePackages.qtsvg
        # ffmpeg-headless
        kdePackages.ffmpegthumbs
        kdePackages.kio-fuse
      ];
    };
  };
}
