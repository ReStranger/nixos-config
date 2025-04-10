{ config
, lib
, ...
}:

let
  cfg = config.module.lazygit;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.lazygit.enable = mkEnableOption "Enable lazygit module";

  config = mkIf cfg.enable {
    programs.lazygit.enable = true;
  };
}

