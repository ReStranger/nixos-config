{ lib
, config
, ...
}:

with lib;

let
  cfg = config.module.services.upower;
in
{
  options.module.services.upower.enable = mkEnableOption "Enable upower";
  config = mkIf cfg.enable {
    services.upower.enable = true;
  };
}
