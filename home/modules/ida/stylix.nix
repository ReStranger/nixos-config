{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.module.ida;
  inherit
    (lib)
    concatStringsSep
    mapAttrsToList
    mkIf
    removeSuffix
    ;

  colors = config.lib.stylix.colors;

  inherit (colors) withHashtag;

  channel = name: axis: colors."${name}-rgb-${axis}";

  rgba = alpha: name: let
    rgb = axis: channel name axis;
  in "rgba(${rgb "r"}, ${rgb "g"}, ${rgb "b"}, ${alpha})";

  slots = {
    rosewater = "base05";
    flamingo = "base0F";
    pink = "base0D";
    mauve = "base0E";
    red = "base08";
    maroon = "base09";
    peach = "base09";
    yellow = "base0A";
    green = "base0B";
    teal = "base0C";
    sky = "base0C";
    sapphire = "base0D";
    blue = "base0D";
    lavender = "base0E";
    text = "base05";
    subtext1 = "base06";
    subtext0 = "base04";
    overlay2 = "base0F";
    overlay1 = "base04";
    overlay0 = "base03";
    surface2 = "base03";
    surface1 = "base02";
    surface0 = "base01";
    base = "base00";
    mantle = "base01";
    crust = "base00";
  };

  alphas = {
    rosewater = "0.19";
    red = "0.3";
    green = "0.3";
  };

  defs = ''
    @importtheme "_base";

    ${concatStringsSep "\n" (
      mapAttrsToList (name: slot: "@def color-${name} ${withHashtag.${slot}};") slots
    )}

    ${concatStringsSep "\n" (
      mapAttrsToList (name: alpha: "@def color-${name}-rgba ${rgba alpha slots.${name}};") alphas
    )}
  '';

  theme = ''
    ${defs}
    ${builtins.readFile ./theme.css}
  '';

  themeDir = "${config.home.homeDirectory}/.idapro/themes/stylix";

  themedIcon = file: let
    accent = withHashtag.base0D;
  in
    pkgs.runCommandLocal "ida-${removeSuffix ".png" (baseNameOf file)}-icon" {
      nativeBuildInputs = [pkgs.imagemagick];
    } ''
      magick ${file} -alpha set -channel RGB -fill '${accent}' -colorize 100% $out
    '';
in {
  config = mkIf cfg.enable {
    home.file = {
      "${themeDir}/theme.css".text = theme;
      "${themeDir}/icons/expand.png".source = themedIcon ./icons/expand.png;
      "${themeDir}/icons/spacer.png".source = themedIcon ./icons/spacer.png;
    };
  };
}
