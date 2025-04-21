{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.module.theme.catppuccin-mocha-mauve.qt;
in
{
  options.module.theme.catppuccin-mocha-mauve.qt = {
    enable = mkEnableOption "Enable qt catppuccin-mocha-mauve theme";
  };

  config = mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme.name = "qt5ct";
      style = {
        package = pkgs.catppuccin-qt5ct;
      };
    };
    home.file.".config/qt5ct/qt5ct.conf".text = # conf
      ''
        [Appearance]
        color_scheme_path=/home/restranger/.nix-profile/share/qt5ct/colors/catppuccin-mocha-mauve.conf
        custom_palette=true
        icon_theme=Tela-circle-dracula-dark
        standard_dialogs=gtk3
        style=Fusion

        [Fonts]
        fixed="Google Sans,10,-1,5,50,0,0,0,0,0,Regular"
        general="Google Sans,10,-1,5,50,0,0,0,0,0,Regular"

        [Interface]
        activate_item_on_single_click=1
        buttonbox_layout=0
        cursor_flash_time=1000
        dialog_buttons_have_icons=1
        double_click_interval=400
        gui_effects=@Invalid()
        keyboard_scheme=2
        menus_have_icons=true
        show_shortcuts_in_context_menus=true
        stylesheets=@Invalid()
        toolbutton_style=4
        underline_shortcut=1
        wheel_scroll_lines=3

        [SettingsWindow]
        geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\0\0\0\0\0\0\0\0\x2\x1e\0\0\x2L\0\0\0\0\0\0\0\0\0\0\x2\x1e\0\0\x2L\0\0\0\0\x2\0\0\0\a\x80\0\0\0\0\0\0\0\0\0\0\x2\x1e\0\0\x2L)

        [Troubleshooting]
        force_raster_widgets=1
        ignored_applications=@Invalid()
      '';
  };
}
