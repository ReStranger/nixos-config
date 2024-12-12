{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.module.theme.catppuccin-mocha-mauve.gtk;
in
{
  options.module.theme.catppuccin-mocha-mauve.gtk = {
    enable = mkEnableOption "Enable gtk catppuccin-mocha-mauve theme";
  };

  config = mkIf cfg.enable {
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
    gtk = {
      enable = true;
      theme = {
        name = "catppuccin-mocha-mauve-standard";
        package = pkgs.catppuccin-gtk.override {
          accents = [ "mauve" ];
          size = "standard";
          variant = "mocha";
        };
      };
      iconTheme = {
        name = "Tela-circle-dracula-dark";
        package = pkgs.tela-circle-icon-theme.override {
          colorVariants = [ "dracula" ];
        };
      };
      font = {
        name = "Google Sans";
        size = 10;
      };
      gtk2.extraConfig =
        ''
          gtk-toolbar-style=GTK_TOOLBAR_ICONS
          gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
          gtk-button-images=0
          gtk-menu-images=0
          gtk-enable-event-sounds=1
          gtk-enable-input-feedback-sounds=0
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle="hintslight"
          gtk-xft-rgba="rgb"
        '';
      gtk3.extraConfig = {
        Settings = ''
          gtk-toolbar-style=GTK_TOOLBAR_ICONS
          gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
          gtk-button-images=0
          gtk-menu-images=0
          gtk-enable-event-sounds=1
          gtk-enable-input-feedback-sounds=0
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle=hintslight
          gtk-xft-rgba=rgb
          gtk-application-prefer-dark-theme=1
        '';
      };

      gtk4.extraConfig = {
        Settings = ''
          gtk-toolbar-style=GTK_TOOLBAR_ICONS
          gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
          gtk-button-images=0
          gtk-menu-images=0
          gtk-enable-event-sounds=1
          gtk-enable-input-feedback-sounds=0
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle=hintslight
          gtk-xft-rgba=rgb
          gtk-application-prefer-dark-theme=1
        '';
      };
    };
  };
}
