{
  lib,
  config,
  ...
}:

let
  cfg = config.module.programs.nekoray;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.programs.nekoray = {
    enable = mkEnableOption "Enable nekoray";
  };

  config = mkIf cfg.enable {
    programs.nekoray = {
      enable = true;
      tunMode.enable = true;
    };
  };
}
