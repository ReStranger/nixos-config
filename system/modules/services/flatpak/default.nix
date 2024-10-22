{
  lib
  , config
  , ...
}:

with lib;

let
  cfg = config.module.services.flatpak;
in {
  options.module.services.flatpak.enable = mkEnableOption "Enable flatpak";
  config = mkIf cfg.enable {
    services.flatpak.enable = true;
  };
}


