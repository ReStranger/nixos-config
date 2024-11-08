{ config
, lib
, ...
}:

with lib;

let
  cfg = config.module.ccache;
in {
  options.module.ccache = {
    enable = mkEnableOption "Enable ccache module";
  };

  config = mkIf cfg.enable {
    programs.ccache.enable = true;
  };
}
