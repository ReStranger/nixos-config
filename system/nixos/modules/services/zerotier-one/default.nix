{
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.module.services.zerotier-one;
in
{
  options.module.services.zerotier-one.enable = mkEnableOption "Enable zerotier-one";
  config = mkIf cfg.enable {
    services.zerotierone.enable = true;
  };
}
