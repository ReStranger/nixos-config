{
  config,
  lib,
  ...
}:

let
  cfg = config.module.kdeconnect;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.kdeconnect.enable = mkEnableOption "Enable kdeconnect module";

  config = mkIf cfg.enable {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
