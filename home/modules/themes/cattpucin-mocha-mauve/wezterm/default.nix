{ config
, lib
, ...
}:

with lib;

let
  cfg = config.module.theme.cattpucin-mocha-mauve.wezterm;
in {
  options.module.theme.cattpucin-mocha-mauve.wezterm = {
  enable = mkEnableOption "Enable wezterm cattpucin-mocha-mauve theme";
  };

  config = mkIf cfg.enable {
    programs.wezterm = {
      extraConfig = ''
local wezterm = require "wezterm"

function scheme_for_appearance(appearance)
  if appearance:find "Dark" then
    return "Catppuccin Mocha"
  else
    return "Catppuccin Latte"
  end
end

return {
  -- ...your existing config
  color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
}
      '';
    };
  };
}
