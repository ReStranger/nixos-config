{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.module.millennium;
  inherit (lib) mkEnableOption mkIf;
in {
  options.module.millennium = {
    enable = mkEnableOption "Enable millennium module";
  };

  config = mkIf cfg.enable {
    programs.steam = {
      plugins = with pkgs.millenniumPlugins; [
        non-steam-playtimes
        protondb
        size-on-disk
      ];
    };
  };
}
