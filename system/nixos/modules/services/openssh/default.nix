{
  lib,
  config,
  ...
}:

let
  cfg = config.module.services.openssh;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.services.openssh.enable = mkEnableOption "Enable openssh";
  config = mkIf cfg.enable {
    services.openssh.enable = true;
  };
}
