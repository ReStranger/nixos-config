{ config
, lib
, ...
}:

with lib;

let
  cfg = config.module.programs.name;
in
{
  options.module.programs.name = {
    enable = mkEnableOption "Enable name program";
  };

  config = mkIf cfg.enable { };
}
