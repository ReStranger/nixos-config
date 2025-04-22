{
  config,
  lib,
  ...
}:

let
  cfg = config.module.variables;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.variables = {
    enable = mkEnableOption "Enable variables module";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      BROWSER = "firefox.desktop";
      TERMINAL = "wezterm";
    };
  };
}
