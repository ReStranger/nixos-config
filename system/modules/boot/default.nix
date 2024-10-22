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
          efiSysMountPoint = "/boot/efi";
        };
        grub = {
          efiSupport = true;
          device = "nodev";
          useOSProber = true;
        };
      };
    };
  };
}
