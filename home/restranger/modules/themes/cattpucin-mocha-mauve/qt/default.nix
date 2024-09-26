{ pkgs, ...}:
{
  environment.systemPackages = with pkgs;
    [
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.lightly
    ];
  environment.variables.QT_QPA_PLATFORMTHEME = "qt5ct";
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = {
      package = pkgs.catppuccin-kvantum;
      name = "kvantum";
    };
  };
}
