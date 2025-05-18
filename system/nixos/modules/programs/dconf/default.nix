{
  lib,
  config,
  ...
}:

let
  cfg = config.module.programs.dconf;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.programs.dconf.enable = mkEnableOption "Enable dconf";

  config = mkIf cfg.enable {
    programs.dconf.enable = true;
  };
}
