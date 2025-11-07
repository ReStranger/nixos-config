{
  lib,
  config,
  ...
}:

let
  cfg = config.module.services.irqbalance;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.services.irqbalance.enable = mkEnableOption "Enable irqbalance daemon";
  config = mkIf cfg.enable {
    services.irqbalance.enable = true;
  };
}
