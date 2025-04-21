{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.module.programs.fonts;
in
{
  options.module.programs.fonts.enable = mkEnableOption "Enable System fonts";

  config = mkIf cfg.enable {
    fonts = {
      fontDir.enable = true;
      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        liberation_ttf
        corefonts
        vistafonts
        nerd-fonts.jetbrains-mono
        nerd-fonts.caskaydia-cove
        nerd-fonts.inconsolata
        nerd-fonts.fira-code
        nerd-fonts.hack
      ];
    };
  };
}
