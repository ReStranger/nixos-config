{
  lib
  , config
  , ...
}:

with lib;

let
  cfg = config.module.services.openssh;
in {
  options.module.services.openssh.enable = mkEnableOption "Enable openssh";
  config = mkIf cfg.enable {
    services.openssh.enable = true;
  };
}


