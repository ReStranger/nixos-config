{
  config,
  lib,
  ...
}:

let
  cfg = config.module.services.tailscale;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.services.tailscale = {
    enable = mkEnableOption "Enable tailscale service";
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      interfaceName = "userspace-networking";
      extraDaemonFlags = [ "--no-logs-no-support" ];
    };
  };
}
