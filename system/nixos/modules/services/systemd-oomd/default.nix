{
  lib,
  config,
  ...
}: let
  cfg = config.module.services.systemd-oomd;
  inherit (lib) mkEnableOption mkIf;
in {
  options.module.services.systemd-oomd.enable = mkEnableOption "Enable systemd-oomd";
  config = mkIf cfg.enable {
    systemd = {
      oomd = {
        enable = true;
        enableUserSlices = true;
        extraConfig = {
          DefaultMemoryPressureDurationSec = "30s";
          DefaultMemoryPressureLimit = "90%";
        };
      };
      slices."user".sliceConfig = {
        ManagedOOMMemoryPressure = "kill";
        ManagedOOMMemoryPressureLimit = "90%";
        ManagedOOMSwap = "kill";
      };
    };
  };
}
