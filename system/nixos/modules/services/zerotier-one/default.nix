{
  lib,
  config,
  ...
}:

let
  cfg = config.module.services.zerotier-one;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.services.zerotier-one.enable = mkEnableOption "Enable zerotier-one";
  config = mkIf cfg.enable {
    services.zerotierone.enable = true;
  };
}
