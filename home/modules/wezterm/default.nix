{
  config,
  lib,
  inputs,
  pkgs,
  theme,
  ...
}:

let
  cfg = config.module.wezterm;
  inherit (lib) mkEnableOption mkIf;
  font = if theme == "touka" then "Caskaydia Cove Nerd Font" else config.stylix.fonts.serif.name;
in
{
  options.module.wezterm = {
    enable = mkEnableOption "Enable wezterm module";
  };

  config = mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      package = inputs.wezterm.packages.${pkgs.system}.default;
      extraConfig = # lua
        ''
          local wezterm = require("wezterm")
          local config = {}

          config.window_decorations = "NONE"
          config.font = wezterm.font("${font}")

          config.enable_tab_bar = true
          config.hide_tab_bar_if_only_one_tab = true

          config.window_background_opacity = 1.0

          config.window_padding = {
          	left = 0,
          	right = 0,
          	top = 0,
          	bottom = 0,
          }

          return config
        '';
    };
  };
}
