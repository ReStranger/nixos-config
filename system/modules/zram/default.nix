{
  lib
  , config
  , ...
}:

with lib;

let
  cfg = config.module.zram;
in {
  options = {
    modules.zram = {
      enable = mkEnableOption "Enable zram";
      deviceNumber = mkOption {
        type = types.number;
          default = 1;
          description = ''
            Change number of ram devices
          '';
      };
    };
  };
  config = mkIf cfg.enable {
    zramSwap = {
      enable = true;
      priority = 32767;
      swapDevices = cfg.deviceNumber;
    };
    boot.kernelParams = [
      "zswap.enabled=0"
    ];
  };
}