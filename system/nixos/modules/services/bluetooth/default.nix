{
  config,
  lib,
  ...
}:

let
  cfg = config.module.services.bluetooth;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.services.bluetooth = {
    enable = mkEnableOption "Enable bluetooth program";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };
}
