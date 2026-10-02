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
    # `colors.withHashtag` is `colors` with every value prefixed by `#`.
    inherit
      (colors.withHashtag)
      base00
      base01
      base03
      base04
      base05
      base06
      base08
      base09
      base0A
      base0B
      base0C
      base0D
      base0E
      ;

    vars = {
      base = base00;
      surface = base01;
      overlay = base03;
      muted = base04;
      text = base05;
      textAlt = base06;

      red = base08;
      orange = base09;
      yellow = base0A;
      green = base0B;
      cyan = base0C;
      blue = base0D;
      purple = base0E;

      # Tinted backgrounds. Pi distinguishes the selection, the user's
      # messages and every kind of tool output by hue, which base16 alone
      # does not provide.
      selected = mix 0.14 "base02" "base0D";
      userBg = mix 0.04 "base01" "base05";
      customBg = mix 0.10 "base01" "base0E";
      pendingBg = mix 0.10 "base01" "base0C";
      successBg = mix 0.12 "base01" "base0B";
      errorBg = mix 0.12 "base01" "base08";
      exportInfoBg = mix 0.12 "base01" "base0A";
    };
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

    inherit vars;

    colors = {
      accent = "blue";
      border = "textAlt";
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
      scrollbarTrack = "muted";
      scrollbarThumb = "text";
      searchMatchBg = "selected";
      searchMatchText = "text";
      userMessageBg = "userBg";
      userMessageText = "text";
      customMessageBg = "customBg";
      customMessageText = "text";
      customMessageLabel = "purple";
      toolPendingBg = "pendingBg";
      toolSuccessBg = "successBg";
      toolErrorBg = "errorBg";
      toolTitle = "text";
      toolOutput = "textAlt";

      mdHeading = "yellow";
      mdLink = "blue";
      mdLinkUrl = "muted";
      mdCode = "cyan";
      mdCodeBlock = "green";
      mdCodeBlockBorder = "muted";
      mdQuote = "textAlt";
      mdQuoteBorder = "muted";
      mdHr = "muted";
      mdListBullet = "cyan";

      toolDiffAdded = "green";
      toolDiffRemoved = "red";
      toolDiffContext = "muted";

      syntaxComment = "textAlt";
      syntaxKeyword = "purple";
      syntaxFunction = "blue";
      syntaxVariable = "red";
      syntaxString = "green";
      syntaxNumber = "orange";
      syntaxType = "yellow";
      syntaxOperator = "textAlt";
      syntaxPunctuation = "textAlt";

      thinkingOff = "muted";
      thinkingMinimal = "textAlt";
      thinkingLow = "cyan";
      thinkingMedium = "blue";
      thinkingHigh = "purple";
      thinkingXhigh = "red";
      thinkingMax = "orange";

      bashMode = "yellow";
    };

    export = {
      pageBg = vars.base;
      cardBg = vars.surface;
      infoBg = vars.exportInfoBg;
    };
  };
in {
  config = mkIf cfg.enable {
    xdg.configFile."pi/agent/themes/stylix.json".source =
      jsonFormat.generate "pi-theme-stylix.json" mkPiTheme;
  };
}
