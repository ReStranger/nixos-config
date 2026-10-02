{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.module.pi-coding-agent;
  inherit
    (lib)
    fixedWidthString
    mkIf
    toHexString
    ;

  jsonFormat = pkgs.formats.json {};
  colors = config.lib.stylix.colors;

  hex = name: "#${colors.${name}}";

  # One channel of the base16 colour `«name»`, as a float between 0 and 1.
  channel = name: axis: builtins.fromJSON colors."${name}-dec-${axis}";

  # Mix two base16 colours in sRGB space, `weight` being the share of `to`.
  mix = weight: from: to: let
    hex = axis:
      fixedWidthString 2 "0" (toHexString (builtins.floor (255.0
        * (
          (1.0 - weight)
          * channel from axis
          + weight * channel to axis
        ))));
  in "#${hex "r"}${hex "g"}${hex "b"}";

  # Perceived brightness of a base16 colour, from 0 to 1.
  brightness = name:
    0.2126
    * channel name "r"
    + 0.7152 * channel name "g"
    + 0.0722 * channel name "b";

  mkPiTheme = let
    base = hex "base00";
    surface = hex "base01";
    surfaceAlt = hex "base02";
    overlay = hex "base03";
    muted = hex "base04";
    text = hex "base05";
    textAlt = hex "base06";
    textBright = hex "base07";

    red = hex "base08";
    orange = hex "base09";
    yellow = hex "base0A";
    green = hex "base0B";
    cyan = hex "base0C";
    blue = hex "base0D";
    purple = hex "base0E";
    brown = hex "base0F";

    selected = mix 0.14 "base02" "base0D";
    userBg = mix 0.04 "base01" "base05";
    customBg = mix 0.10 "base01" "base0E";
    pendingBg = mix 0.10 "base01" "base0C";
    successBg = mix 0.12 "base01" "base0B";
    errorBg = mix 0.12 "base01" "base08";
    exportInfoBg = mix 0.12 "base01" "base0A";
  in {
    "$schema" = "https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json";
    name = "stylix";

    # Pi has to be told whether the scheme is light or dark.
    # `stylix.polarity` cannot answer that, as it is only a hint to the
    # palette generator and defaults to `either`.
    appearance =
      if brightness "base00" < brightness "base05"
      then "dark"
      else "light";

    vars = {
      inherit
        base
        surface
        surfaceAlt
        overlay
        muted
        text
        textAlt
        textBright
        red
        orange
        yellow
        green
        cyan
        blue
        purple
        brown
        selected
        userBg
        customBg
        pendingBg
        successBg
        errorBg
        ;
    };

    colors = {
      accent = "blue";
      border = "overlay";
      borderAccent = "blue";
      borderMuted = "muted";
      success = "green";
      error = "red";
      warning = "yellow";
      muted = "muted";
      dim = "overlay";
      text = "text";
      thinkingText = "muted";

      selectedBg = "selected";
      userMessageBg = "userBg";
      userMessageText = "text";
      customMessageBg = "customBg";
      customMessageText = "text";
      customMessageLabel = "purple";
      toolPendingBg = "pendingBg";
      toolSuccessBg = "successBg";
      toolErrorBg = "errorBg";
      toolTitle = "text";
      toolOutput = "muted";

      mdHeading = "yellow";
      mdLink = "blue";
      mdLinkUrl = "muted";
      mdCode = "cyan";
      mdCodeBlock = "text";
      mdCodeBlockBorder = "overlay";
      mdQuote = "muted";
      mdQuoteBorder = "overlay";
      mdHr = "overlay";
      mdListBullet = "cyan";

      toolDiffAdded = "green";
      toolDiffRemoved = "red";
      toolDiffContext = "muted";

      syntaxComment = "muted";
      syntaxKeyword = "purple";
      syntaxFunction = "blue";
      syntaxVariable = "red";
      syntaxString = "green";
      syntaxNumber = "orange";
      syntaxType = "yellow";
      syntaxOperator = "text";
      syntaxPunctuation = "muted";

      thinkingOff = "overlay";
      thinkingMinimal = "muted";
      thinkingLow = "cyan";
      thinkingMedium = "blue";
      thinkingHigh = "purple";
      thinkingXhigh = "red";
      thinkingMax = "orange";

      bashMode = "yellow";
    };

    export = {
      pageBg = base;
      cardBg = surface;
      infoBg = exportInfoBg;
    };
  };
in {
  config = mkIf cfg.enable {
    xdg.configFile."pi/agent/themes/stylix.json".source =
      jsonFormat.generate "pi-theme-stylix.json" mkPiTheme;
  };
}
