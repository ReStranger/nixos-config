{
  config,
  lib,
  pkgs,
  theme,
  ...
}: let
  cfg = config.module.qt;
  inherit (lib) mkEnableOption mkIf mkForce;

  stylixEnabled = config.stylix.base16Scheme != null;

  formatValue = value:
    if lib.isBool value
    then
      if value
      then "true"
      else "false"
    else toString value;

  formatSection = path: data: let
    header = lib.concatStrings (map (p: "[${p}]") path);
    formatChild = name: formatLines (path ++ [name]);
    children = lib.mapAttrsToList formatChild data;
    partitioned = lib.partition lib.isString children;
    directChildren = partitioned.right;
    indirectChildren = partitioned.wrong;
  in
    lib.optional (directChildren != []) header
    ++ directChildren
    ++ lib.flatten indirectChildren;

  formatLines = path: data:
    if lib.isAttrs data
    then formatSection path data
    else "${lib.last path}=${formatValue data}";

  formatConfig = data: lib.concatStringsSep "\n" (formatLines [] data);

  mkColorTriple = colors: name:
    lib.concatStringsSep "," (
      map (color: colors."${name}-rgb-${color}") [
        "r"
        "g"
        "b"
      ]
    );

  stylixQtColorScheme = let
    inherit (config.lib.stylix) colors;
    disabledColorEffect = {
      Color = colors'.base02;
      ColorAmount = 0.3;
      ColorEffect = 2;
      ContrastAmount = 0.1;
      ContrastEffect = 0;
      IntensityAmount = -1;
      IntensityEffect = 0;
    };

    inactiveColorEffect = {
      ChangeSelectionColor = false;
      Color = colors'.base02;
      ColorAmount = 0.5;
      ColorEffect = 3;
      ContrastAmount = 0;
      ContrastEffect = 0;
      Enable = true;
      IntensityAmount = 0;
      IntensityEffect = 0;
    };

    mkColorMapping = num: let
      hex = "base0${lib.toHexString num}";
    in {
      name = hex;
      value = mkColorTriple colors hex;
    };

    colors' = builtins.listToAttrs (map mkColorMapping (lib.range 0 15));

    kdecolors = with colors'; {
      BackgroundNormal = base00;
      BackgroundAlternate = base01;
      DecorationFocus = base0D;
      DecorationHover = base03;
      ForegroundNormal = base05;
      ForegroundActive = base0A;
      ForegroundInactive = base04;
      ForegroundLink = base0C;
      ForegroundVisited = base05;
      ForegroundNegative = base08;
      ForegroundNeutral = base0A;
      ForegroundPositive = base0B;
    };

    complementaryColors = with colors'; {
      BackgroundNormal = base01;
      BackgroundAlternate = base00;
      DecorationFocus = base0D;
      DecorationHover = base03;
      ForegroundNormal = base05;
      ForegroundActive = base0A;
      ForegroundInactive = base04;
      ForegroundLink = base0C;
      ForegroundVisited = base05;
      ForegroundNegative = base08;
      ForegroundNeutral = base0A;
      ForegroundPositive = base0B;
    };

    colorscheme = {
      General = {
        ColorScheme = "Stylix";
        Name = "Stylix";
        accentActiveTitlebar = false;
        shadeSortColumn = true;
      };

      "ColorEffects:Disabled" = disabledColorEffect;
      "ColorEffects:Inactive" = inactiveColorEffect;

      "Colors:Window" = kdecolors;
      "Colors:View" = kdecolors;
      "Colors:Button" = kdecolors;
      "Colors:Tooltip" = complementaryColors;
      "Colors:Complementary" = complementaryColors;
      "Colors:Header" = complementaryColors;
      "Colors:Selection" =
        complementaryColors
        // (with colors'; {
          BackgroundNormal = base0D;
          BackgroundAlternate = base0D;
          ForegroundNormal = base00;
          ForegroundActive = base00;
          ForegroundInactive = base00;
          ForegroundLink = base00;
          ForegroundNegative = base00;
          ForegroundNeutral = base00;
          ForegroundPositive = base00;
          ForegroundVisited = base00;
          DecorationFocus = base0D;
          DecorationHover = base0E;
        });

      WM = with colors'; {
        activeBlend = base05;
        activeBackground = base00;
        activeForeground = base05;
        inactiveBlend = base04;
        inactiveBackground = base01;
        inactiveForeground = base04;
      };

      KDE = {
        contrast = 4;
      };
    };
  in
    pkgs.writeText "stylix.colors" (formatConfig colorscheme);

  iconTheme =
    {
      catppuccin-mocha = "Tela-circle-dracula-dark";
      touka = "Papirus-Dark";
    }.${
      theme
    } or "MoreWaita";

  qt6ColorSchemePath = "${config.xdg.configHome}/qt6ct/colors/stylix.colors";

  qtSettings = {
    Appearance = {
      icon_theme = iconTheme;
      standard_dialogs = mkForce "xdgdesktopportal";
    };
  };

  qt6Settings =
    qtSettings
    // {
      Appearance =
        qtSettings.Appearance
        // lib.optionalAttrs stylixEnabled {
          custom_palette = true;
          color_scheme_path = qt6ColorSchemePath;
        };
    };
in {
  options.module.qt = {
    enable = mkEnableOption "Enable qt module";
  };

  config = mkIf cfg.enable {
    xdg.configFile = lib.optionalAttrs stylixEnabled {
      "qt6ct/colors/stylix.colors".source = stylixQtColorScheme;
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "kvantum";
      qt5ctSettings = qtSettings;
      qt6ctSettings = qt6Settings;
    };
  };
}
