{ config
, lib
, ...
}:

let
  cfg = config.module.service.name;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.service.name = {
    enable = mkEnableOption "Enable name program";
  };

  config = mkIf cfg.enable { };
}
