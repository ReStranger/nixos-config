{
  lib,
  config,
  ...
}:

let
  cfg = config.module.programs.gamemode;
  inherit (lib) mkEnableOption mkIf;
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
