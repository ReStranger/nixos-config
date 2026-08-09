{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.module.ida;
  inherit (lib) mkIf fromHexString removePrefix concatStringsSep drop splitString removeSuffix;

  colors = config.lib.stylix.colors;

  hexPairToInt = pair:
    builtins.fromJSON "${toString (fromHexString pair)}";

  hexToRgb = hex: let
    value = removePrefix "#" hex;
  in {
    r = hexPairToInt (builtins.substring 0 2 value);
    g = hexPairToInt (builtins.substring 2 2 value);
    b = hexPairToInt (builtins.substring 4 2 value);
  };

  rgba = hex: alpha: let
    rgb = hexToRgb hex;
  in "rgba(${toString rgb.r}, ${toString rgb.g}, ${toString rgb.b}, ${alpha})";

  idaThemeTemplate = builtins.readFile (pkgs.writeText "ida-theme-template.css" ''
    ${concatStringsSep "\n" (drop 54 (splitString "\n" (builtins.readFile ./theme.css)))}
  '');

  idaTheme = let
    colorRosewater = "#${colors.base05}";
    colorFlamingo = "#${colors.base0F}";
    colorPink = "#${colors.base0D}";
    colorMauve = "#${colors.base0E}";
    colorRed = "#${colors.base08}";
    colorMaroon = "#${colors.base09}";
    colorPeach = "#${colors.base09}";
    colorYellow = "#${colors.base0A}";
    colorGreen = "#${colors.base0B}";
    colorTeal = "#${colors.base0C}";
    colorSky = "#${colors.base0C}";
    colorSapphire = "#${colors.base0D}";
    colorBlue = "#${colors.base0D}";
    colorLavender = "#${colors.base0E}";
    colorText = "#${colors.base05}";
    colorSubtext1 = "#${colors.base06}";
    colorSubtext0 = "#${colors.base04}";
    colorOverlay2 = "#${colors.base0F}";
    colorOverlay1 = "#${colors.base04}";
    colorOverlay0 = "#${colors.base03}";
    colorSurface2 = "#${colors.base03}";
    colorSurface1 = "#${colors.base02}";
    colorSurface0 = "#${colors.base01}";
    colorBase = "#${colors.base00}";
    colorMantle = "#${colors.base01}";
    colorCrust = "#${colors.base00}";
  in
    builtins.readFile (pkgs.writeText "ida-theme.css" ''
      @importtheme "_base";

      @def color-rosewater  ${colorRosewater};
      @def color-flamingo ${colorFlamingo};
      @def color-pink ${colorPink};
      @def color-mauve  ${colorMauve};
      @def color-red  ${colorRed};
      @def color-maroon ${colorMaroon};
      @def color-peach  ${colorPeach};
      @def color-yellow ${colorYellow};
      @def color-green  ${colorGreen};
      @def color-teal ${colorTeal};
      @def color-sky  ${colorSky};
      @def color-sapphire ${colorSapphire};
      @def color-blue ${colorBlue};
      @def color-lavender ${colorLavender};
      @def color-text ${colorText};
      @def color-subtext1 ${colorSubtext1};
      @def color-subtext0 ${colorSubtext0};
      @def color-overlay2 ${colorOverlay2};
      @def color-overlay1 ${colorOverlay1};
      @def color-overlay0 ${colorOverlay0};
      @def color-surface2 ${colorSurface2};
      @def color-surface1 ${colorSurface1};
      @def color-surface0 ${colorSurface0};
      @def color-base ${colorBase};
      @def color-mantle ${colorMantle};
      @def color-crust  ${colorCrust};
      @def color-rosewater-rgba ${rgba colorRosewater "0.19"};
      @def color-flamingo-rgba ${rgba colorFlamingo "1"};
      @def color-pink-rgba ${rgba colorPink "1"};
      @def color-mauve-rgba ${rgba colorMauve "1"};
      @def color-red-rgba ${rgba colorRed "0.3"};
      @def color-maroon-rgba ${rgba colorMaroon "1"};
      @def color-peach-rgba ${rgba colorPeach "1"};
      @def color-yellow-rgba ${rgba colorYellow "1"};
      @def color-green-rgba ${rgba colorGreen "0.3"};
      @def color-teal-rgba ${rgba colorTeal "1"};
      @def color-sky-rgba ${rgba colorSky "1"};
      @def color-sapphire-rgba ${rgba colorSapphire "1"};
      @def color-blue-rgba ${rgba colorBlue "1"};
      @def color-lavender-rgba ${rgba colorLavender "1"};
      @def color-text-rgba ${rgba colorText "1"};
      @def color-subtext1-rgba ${rgba colorSubtext1 "1"};
      @def color-subtext0-rgba ${rgba colorSubtext0 "1"};
      @def color-overlay2-rgba ${rgba colorOverlay2 "1"};
      @def color-overlay1-rgba ${rgba colorOverlay1 "1"};
      @def color-overlay0-rgba ${rgba colorOverlay0 "1"};
      @def color-surface2-rgba ${rgba colorSurface2 "1"};
      @def color-surface1-rgba ${rgba colorSurface1 "1"};
      @def color-surface0-rgba ${rgba colorSurface0 "1"};
      @def color-base-rgba ${rgba colorBase "1"};
      @def color-mantle-rgba ${rgba colorMantle "1"};
      @def color-crust-rgba ${rgba colorCrust "1"};

      ${idaThemeTemplate}
    '');

  themedIcon = icon: let
    accent = "#${colors.base0D}";
  in
    pkgs.runCommand "ida-${removeSuffix ".png" (baseNameOf icon)}-icon" {
      nativeBuildInputs = [pkgs.imagemagick];
    } ''
      magick ${icon} -alpha set -channel RGB -fill '${accent}' -colorize 100% $out
    '';
in {
  config = mkIf cfg.enable {
    home.file.".idapro/themes/stylix/theme.css".text = idaTheme;
    home.file.".idapro/themes/stylix/icons/expand.png".source = themedIcon ./icons/expand.png;
    home.file.".idapro/themes/stylix/icons/spacer.png".source = themedIcon ./icons/spacer.png;
  };
}
