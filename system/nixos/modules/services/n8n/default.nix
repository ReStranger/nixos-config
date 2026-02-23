{
  config,
  lib,
  ...
}:

let
  cfg = config.module.services.n8n;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.services.n8n = {
    enable = mkEnableOption "Enable n8n service";
  };

  config = mkIf cfg.enable {
    services.n8n = {
      enable = true;
    };
  };
}
