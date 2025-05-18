{
  lib,
  config,
  ...
}:

let
  cfg = config.module.services.opentablet;
  inherit (lib) mkEnableOption mkIf;
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
