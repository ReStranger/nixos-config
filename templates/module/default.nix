{
  config,
  lib,
  ...
}:

let
  cfg = config.module.name;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.name = {
    enable = mkEnableOption "Enable name module";
  };

  config = mkIf cfg.enable { };
}
