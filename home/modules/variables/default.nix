{ config
, lib
, ...
}:

with lib;

let
  cfg = config.module.variables;
in
{
  options.module.variables = {
    enable = mkEnableOption "Enable variables module";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "alacritty";
    };
  };
}