{
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.module.services.auto-cpufreq;
in
{
  options.module.services.auto-cpufreq.enable = mkEnableOption "Enable auto-cpufreq";
  config = mkIf cfg.enable {
    services.auto-cpufreq.enable = true;
    services.auto-cpufreq.settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
}
