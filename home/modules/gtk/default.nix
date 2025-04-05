{ config
, lib
, pkgs
, theme
, ...
}:

let
  cfg = config.module.gtk;
  inherit (lib) mkEnableOption mkIf;
in
{

  options.module.gtk = {
    enable = mkEnableOption "Enable gtk module";
  };

  config = mkIf cfg.enable {

    gtk = {
      enable = true;
      iconTheme = if theme == "catppuccin-mocha" then {
        name = "Tela-circle-dracula-dark";
        package = pkgs.tela-circle-icon-theme.override {
          colorVariants = [ "dracula" ];
        };
      } else if theme == "touka" then {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      } else {
        name = "MoreWaita";
        package = pkgs.morewaita-icon-theme;
      };
    };
  };
}
