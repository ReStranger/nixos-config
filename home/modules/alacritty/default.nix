{
  config,
  lib,
  ...
}: let
  cfg = config.module.alacritty;
  inherit
    (lib)
    mkEnableOption
    mkOption
    mkForce
    mkIf
    ;
  inherit (lib.types) str;
in {
  options.module.alacritty = {
    enable = mkEnableOption "Enable alacritty module";
    font = mkOption {
      type = str;
      default = "Maple Mono NF";
      description = ''
        Font for alacritty module
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        general.live_config_reload = true;
        env = {
          TERM = "xterm-256color";
          WINIT_X11_SCALE_FACTOR = "1.0";
        };

        window = {
          opacity = mkForce 0.87;
          blur = true;
        };

        font = {
          normal = {
            family = mkForce "${cfg.font}";
            style = "Regular";
          };
          bold = {
            family = mkForce "${cfg.font}";
            style = "Bold";
          };
          italic = {
            family = mkForce "${cfg.font}";
            style = "Italic";
          };
          bold_italic = {
            family = mkForce "${cfg.font}";
            style = "BoldItalic";
          };
        };
      };
    };
  };
}
