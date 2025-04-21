{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.module.theme.catppuccin-mocha-mauve.imv;
in
{
  options.module.theme.catppuccin-mocha-mauve.imv = {
    enable = mkEnableOption "Enable imv catppuccin-mocha-mauve theme";
  };

  config = mkIf cfg.enable {
    programs.imv.settings = {
      options = {
        background = "1e1e2e";
        overlay_text_color = "cdd6f4";
        overlay_background_color = "11111b";
      };
    };
  };
}
