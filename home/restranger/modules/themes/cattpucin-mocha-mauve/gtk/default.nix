{ pkgs, ... }:
{
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
    gtk2.extraConfig =
      ''
        gtk-font-name="Comfortaa 10"
        gtk-cursor-theme-name="Bibata-Modern-Classic"
        gtk-cursor-theme-size=24
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
        gtk-font-name=Comfortaa 10
        gtk-cursor-theme-name=Bibata-Modern-Classic
        gtk-cursor-theme-size=24
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
        gtk-font-name=Comfortaa 10
        gtk-cursor-theme-name=Bibata-Modern-Classic
        gtk-cursor-theme-size=24
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
}
