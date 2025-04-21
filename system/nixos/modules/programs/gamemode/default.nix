{
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.module.programs.gamemode;
in
{
  options.module.programs.gamemode = {
    enable = mkEnableOption "Enable gamemode";
  };

  config = mkIf cfg.enable {
    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        custom = {
          start = "notify-send -a 'Gamemode' 'Optimizations activated'";
          end = "notify-send -a 'Gamemode' 'Optimizations deactivated'";
        };
      };
    };
  };
}
