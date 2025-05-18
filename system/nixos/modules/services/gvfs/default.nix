{
  lib,
  config,
  ...
}:

let
  cfg = config.module.services.gvfs;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.services.gvfs = {
    enable = mkEnableOption "Enable gvfs";
  };
  config = mkIf cfg.enable {
    services.gvfs.enable = true;
  };
}
