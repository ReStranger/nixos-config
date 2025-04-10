{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.module.ripgrep;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.ripgrep.enable = mkEnableOption "Enable ripgrep module";

  config = mkIf cfg.enable {
    programs.ripgrep = {
        enable = true;
        package = pkgs.ripgrep;
    };
  };
}
