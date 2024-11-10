{ config
, lib
, ...
}:

with lib;

let
  cfg = config.module.theme.cattpucin-mocha-mauve.wezterm;
in {
  options.module.theme.cattpucin-mocha-mauve.wezterm = {
  enable = mkEnableOption "Enable wezterm cattpucin-mocha-mauve theme";
  };

  config = mkIf cfg.enable {
    programs.wezterm = {
      extraConfig = ''
      '';
    };
  };
}
