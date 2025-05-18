{
  lib,
  config,
  ...
}:

let
  cfg = config.module.services.upower;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.services.upower.enable = mkEnableOption "Enable upower";
  config = mkIf cfg.enable {
    services.upower.enable = true;
  };
}
