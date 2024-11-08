{ config
, lib
, ...
}:

with lib;

let
  cfg = config.module.name;
in {
  options.module.name = {
    enable = mkEnableOption "Enable name module";
  };

  config = mkIf cfg.enable {
  };
}
