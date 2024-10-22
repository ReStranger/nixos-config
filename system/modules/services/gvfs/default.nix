{
  lib
  , config
  , ...
}:

with lib;

let
  cfg = config.module.services.openssh;
in {
  options.modules.openssh = {
    enable = mkEnableOption "Enable openssh";
  };
  config = mkIf cfg.enable {
    gvfs.enable = true;
  };
}

