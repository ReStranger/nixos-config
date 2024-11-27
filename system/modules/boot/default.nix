{ lib
, config
, ...
}:
with lib;
let
  cfg = config.module.boot;
in
{
  options.module.boot.enable = mkEnableOption "Enable boot module";
  config = mkIf cfg.enable {
    boot = {
      loader = {
        efi = {
          canTouchEfiVariables = true;
        };
        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          useOSProber = true;
        };
      };
      initrd.luks.devices.cryptroot.device = "/dev/nvme0n1p2";
    };
  };
}
