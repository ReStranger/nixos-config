{ config
, lib
, ...
}:

with lib;

let
  cfg = config.module.service.name;
in
{
  options.module.service.name = {
    enable = mkEnableOption "Enable name program";
  };

  config = mkIf cfg.enable { };
}
