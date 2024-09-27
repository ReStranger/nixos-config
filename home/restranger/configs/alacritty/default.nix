{
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

      font = {
        # normal = { family = "JetBrains Mono Nerd Font"; style = "Regular"; };
        # bold = { family = "JetBrains Mono Nerd Font"; style = "Bold" };
        # italic = { family = "JetBrains Mono Nerd Font"; style = "Italic" };
        # bold_italic = { family = "JetBrains Mono Nerd Font"; style = "BoldItalic" };

        normal = { family = "Operator Mono"; style = "Regular"; };
        bold = { family = "Operator Mono"; style = "Bold"; };
        italic = { family = "Operator Mono"; style = "Italic"; };
        bold_italic = { family = "Operator Mono"; style = "BoldItalic"; };

        size = 11;

        builtin_box_drawing = true;
      };
    };
  };
}
