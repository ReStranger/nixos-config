{
  lib
  , config
  , ...
}:

with lib;

let
  cfg = config.module.services.flatpak;
in {
  options.modules.flatpak = {
    enable = mkEnableOption "Enable flatpak";
  };
  config = mkIf cfg.enable {
    flatpak.enable = true;
  };
}


