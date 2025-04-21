{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.module.theme.catppuccin-mocha-mauve.wezterm;
in
{
  options.module.theme.catppuccin-mocha-mauve.wezterm = {
    enable = mkEnableOption "Enable wezterm catppuccin-mocha-mauve theme";
  };

  config = mkIf cfg.enable {
    programs.wezterm = {
      extraConfig = '''';
    };
  };
}
