{ lib
, config
, ...
}:
with lib;

let
  cfg = config.module.timezone;
in
{
  options.module.timezone.enable = mkEnableOption "Set timezone to Moscow";
  config = mkIf cfg.enable {
    time.timeZone = "Europe/Moscow";
  };
}
