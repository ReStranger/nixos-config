{
  lib,
  config,
  ...
}: let
  cfg = config.module.services.zram;
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.module.services.zram.enable = mkEnableOption "Enable zram";
  config = mkIf cfg.enable {
    zramSwap = {
      enable = true;
      memoryPercent = 200;
      priority = 32767;
      swapDevices = 1;
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
