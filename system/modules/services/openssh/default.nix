{
  lib
  , config
  , ...
}:

with lib;

let
  cfg = config.module.services.openssh;
in {
  options.modules.gvfs = {
    enable = mkEnableOption "Enable openssh";
  };
  config = mkIf cfg.enable {
    openssh.enable = true;
  };
}


