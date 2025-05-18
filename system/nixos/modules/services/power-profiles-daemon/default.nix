{
  lib,
  config,
  ...
}:

let
  cfg = config.module.services.power-profiles-daemon;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.services.power-profiles-daemon.enable =
    mkEnableOption "Enable power-profiles-daemon";
  config = mkIf cfg.enable {
    services.power-profiles-daemon.enable = true;
  };
}
