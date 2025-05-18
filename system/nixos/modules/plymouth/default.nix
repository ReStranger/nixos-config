{
  lib,
  config,
  ...
}:

let
  cfg = config.module.plymouth;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.plymouth.enable = mkEnableOption "Enables plymouth";

  config = mkIf cfg.enable {
    boot.plymouth = {
      enable = true;
    };
  };
}
