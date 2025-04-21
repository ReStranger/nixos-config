{
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.module.services.systemd-oomd;
in
{
  options.module.services.systemd-oomd.enable = mkEnableOption "Enable systemd-oomd";
  config = mkIf cfg.enable {
    systemd.oomd = {
      enable = true;
      extraConfig = {
        DefaultMemoryPressureLimit = "90%";
        DefaultMemoryPressureDurationSec = "10s";
      };
    };
  };
}
