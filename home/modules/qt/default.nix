{
  config,
  lib,
  theme,
  ...
}: let
  cfg = config.module.qt;
  inherit (lib) mkEnableOption mkIf mkForce;

  iconTheme =
    {
      catppuccin-mocha = "Tela-circle-dracula-dark";
      touka = "Papirus-Dark";
    }.${
      theme
    } or "MoreWaita";

  qtSettings = {
    Appearance = {
      icon_theme = iconTheme;
      standard_dialogs = mkForce "xdgdesktopportal";
    };
  };
in {
  options.module.qt = {
    enable = mkEnableOption "Enable qt module";
  };

  config = mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "kvantum";
      qt5ctSettings = qtSettings;
      qt6ctSettings = qtSettings;
    };
  };
}
