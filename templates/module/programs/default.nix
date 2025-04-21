{
  config,
  lib,
  ...
}:

let
  cfg = config.module.programs.name;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.programs.name = {
    enable = mkEnableOption "Enable name program";
  };

  config = mkIf cfg.enable { };
}
