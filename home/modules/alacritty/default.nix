{
  config,
  hostname,
  lib,
  ...
}:

with lib;

let
  cfg = config.module.alacritty;
  inherit (lib) mkEnableOption mkOption mkIf;
in
{
  options.module.alacritty = {
    enable = mkEnableOption "Enable alacritty module";
    font = mkOption {
      type = types.enum [
        "JetBrains Mono Nerd Font"
        "Operator Mono"
      ];
      default = "Operator Mono";
      description = ''
        Font for alacritty module
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        live_config_reload = true;
        env = {
          TERM = "xterm-256color";
          WINIT_X11_SCALE_FACTOR = "1.0";
        };

        window = {
          opacity = 0.87;
          blur = true;
        };

        font =
          if (cfg.font == "JetBrains Mono Nerd Font") then
            {
              normal = {
                family = "JetBrains Mono Nerd Font";
                style = "Regular";
              };
              bold = {
                family = "JetBrains Mono Nerd Font";
                style = "Bold";
              };
              italic = {
                family = "JetBrains Mono Nerd Font";
                style = "Italic";
              };
              bold_italic = {
                family = "JetBrains Mono Nerd Font";
                style = "BoldItalic";
              };
              size =
                if (hostname == "pc") then
                  10
                else if (hostname == "magicbook") then
                  11
                else
                  10;
            }
          else if (cfg.font == "Operator Mono") then
            {
              normal = {
                family = "Operator Mono";
                style = "Regular";
              };
              bold = {
                family = "Operator Mono";
                style = "Bold";
              };
              italic = {
                family = "Operator Mono";
                style = "Italic";
              };
              bold_italic = {
                family = "Operator Mono";
                style = "BoldItalic";
              };
              size =
                if (hostname == "pc") then
                  11
                else if (hostname == "magicbook") then
                  13
                else
                  11;
            }
          else
            { };
        builtin_box_drawing = true;
      };
    };
  };
}
