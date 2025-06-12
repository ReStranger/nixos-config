{
  lib,
  config,
  ...
}:

let
  cfg = config.module.programs.corectrl;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.programs.corectrl.enable = mkEnableOption "Enable corectrl";

  config = mkIf cfg.enable {
    programs.corectrl.enable = true;
  };
}
