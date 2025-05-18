{
  lib,
  config,
  ...
}:
let
  cfg = config.module.boot;
  inherit (lib) mkEnableOption mkIf;
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
    };
  };
}
