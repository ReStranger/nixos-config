{
  lib,
  config,
  ...
}:

let
  cfg = config.module.services.zram;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.module.services.zram = {
    enable = mkEnableOption "Enable zram";
    deviceNumber = mkOption {
      type = types.number;
      default = 1;
      description = ''
        Change number of ram devices
      '';
    };
  };
  config = mkIf cfg.enable {
    zramSwap = {
      enable = true;
      priority = 32767;
      swapDevices = cfg.deviceNumber;
    };
    boot = {
      kernelParams = [
        "zswap.enabled=0"
      ];
      kernel.sysctl = {
        "vm.swappiness" = 180;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
        "vm.page-cluster" = 0;
      };
    };
  };
}
