{ config
, lib
, ...
}:

let
  cfg = config.module.fd;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.fd.enable = mkEnableOption "Enable fd module";

  config = mkIf cfg.enable {
    programs.fd.enable = true;
  };
}
