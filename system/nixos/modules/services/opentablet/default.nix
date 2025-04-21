{
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.module.services.opentablet;
in
{
  options.module.services.opentablet.enable = mkEnableOption "Enable opentablet";
  config = mkIf cfg.enable {
    hardware.opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };
}
