{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.module.firefox;
in
{
  options.module.firefox = {
    enable = mkEnableOption "Enable firefox module";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-devedition-bin;
      languagePacks = [ "ru" ];
    };
  };
}
