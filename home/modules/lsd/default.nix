{
  config,
  lib,
  ...
}:

let
  cfg = config.module.lsd;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.lsd.enable = mkEnableOption "Enable lsd module";

  config = mkIf cfg.enable {
    programs.lsd = {
      enable = true;
      enableAliases = true;
    };
  };
}
