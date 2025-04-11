{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.module.starship;
in
{
  options.module.starship = {
    enable = mkEnableOption "Enable starship module";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
