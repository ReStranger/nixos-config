{
  lib,
  config,
  ...
}:
let
  cfg = config.module.timezone;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.timezone.enable = mkEnableOption "Set timezone to Moscow";
  config = mkIf cfg.enable {
    time.timeZone = "Europe/Moscow";
  };
}
