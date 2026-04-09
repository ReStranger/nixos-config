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
      BROWSER = "zen.desktop";
      TERMINAL = "wezterm";
    };
  };
}
