{
  pkgs,
  lib,
  config,
  hostname,
  theme,
  stateVersion,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption mkIf;
  inherit (lib) optionalAttrs;
  inherit (lib.types) bool;

  cfg = config.module.stylix;

  terminessPackage =
    if stateVersion == "24.11" then
      pkgs.nerdfonts.override { fonts = [ "Terminess" ]; }
    else
      pkgs.nerd-fonts.terminess-ttf;
  jbPackage =
    if stateVersion == "24.11" then
      pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }
    else
      pkgs.nerd-fonts.iosevka;

  themes = {
    catppuccin-mocha = {
      scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      # wallpaper = "${self}/assets/grey_gradient.png";

      font = {
        package = jbPackage;
        name = "JetBrains Mono Nerd Font";
      };

      cursor = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
      };
    };

    gruvbox = {
      scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
      # wallpaper = "${self}/assets/grey_gradient.png";

      font = {
        package = terminessPackage;
        name = "Terminess Nerd Font";
      };

      cursor = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
      };
    };
    touka = {
      scheme = {
        base00 = "#121214";
        base01 = "#212126";
        base02 = "#2a2a30";
        base03 = "#373740";
        base04 = "#676778";
        base05 = "#e9ecf2";
        base06 = "#e9ecf2";
        base07 = "#e9ecf2";
        base08 = "#f25c5c";
        base09 = "#ff9c6a";
        base0A = "#ff9c6a";
        base0B = "#55b682";
        base0C = "#7aaaff";
        base0D = "#f17ac6";
        base0E = "#B87AFF";
        base0F = "#9595ab";
      };
      font = {
        package = pkgs.comfortaa;
        name = "Comfortaa";
      };

      cursor = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
      };
    };
  };
in
{
  options = {
    module.stylix = {
      enable = mkEnableOption "Enables stylix";

      useCursor = mkOption {
        type = bool;
        default = true;
        description = "Enable cursor settings";
      };
    };
  };

  config = mkIf cfg.enable {
    stylix =
      {
        enable = true;
        # image = themes.${theme}.wallpaper;
        autoEnable = true;
        polarity = "dark";
        base16Scheme = themes.${theme}.scheme;
        enableReleaseChecks = false;

        opacity = {
          applications = 1.0;
          terminal = 1.0;
          popups = 1.0;
          desktop = 1.0;
        };

        fonts = {

          serif = {
            inherit (themes.${theme}.font) package name;
          };

          sansSerif = config.stylix.fonts.serif;
          monospace = config.stylix.fonts.serif;
          emoji = config.stylix.fonts.serif;
        };
      }
      // optionalAttrs cfg.useCursor {
        cursor = {
          inherit (themes.${theme}.cursor) package name;
          size = 24;
        };
      };
  };
}
