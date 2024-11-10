{ config
, lib
, ...
}:

with lib;

let
  cfg = config.module.theme.cattpucin-mocha-mauve.mpv;
in
{
  options.module.theme.cattpucin-mocha-mauve.mpv = {
    enable = mkEnableOption "Enable mpv cattpucin-mocha-mauve theme";
  };
  config = mkIf cfg.enable {
    programs.mpv = {
      config = {
        background-color = "#1e1e2e";
        osd-back-color = "#6c7086";
        osd-border-color = "#11111b";
        osd-color = "#cdd6f4";
        osd-shadow-color = "#1e1e2e";
      };
      scriptOpts = {
        stats = {
          border_color = "251818";
          font_color = "f4d6cd";
          plot_bg_border_color = "f7a6cb";
          plot_bg_color = "251818";
          plot_color = "f7a6cb";
        };
      };
    };
  };
}
