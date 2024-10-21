{ lib
  , config
  , ...
}:
with lib;
let
  cfg = config.modules.boot;
in
{
  options.modules.boot = {
    enable = mkEnableOption "Enable boot module";
  };
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
