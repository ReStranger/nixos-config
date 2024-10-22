{ pkgs
, lib
, config
, ...
}:

with lib;

let
  cfg = config.module.programs.fonts;
in {
  options.module.programs.fonts.enable = mkEnableOption "Enable System fonts";

  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      (nerdfonts.override { fonts = [ "JetBrainsMono" "CascadiaCode" ]; })
    ];
  };
}
