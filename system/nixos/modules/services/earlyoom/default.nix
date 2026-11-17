{ lib
, config
, ...
}:
let
  cfg = config.module.services.earlyoom;
  inherit (lib) mkEnableOption mkIf mkMerge;
in
{
  options.module.services.earlyoom.enable = mkEnableOption "Enable earlyoom";
  config = mkMerge [
    {
      assertions = [
        {
          assertion = !(cfg.enable && config.module.services.systemd-oomd.enable);
          message = "Cannot enable both 'module.services.earlyoom' and 'module.services.systemd-oomd' simultaneously.";
        }
      ];
    }
    (mkIf cfg.enable {
      services.earlyoom = {
        enable = true;
        enableNotifications = true;
        freeMemThreshold = 5;
        freeSwapThreshold = 10;
      };
    })
  ];
}
