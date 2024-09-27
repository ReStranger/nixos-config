{ pkgs, ...}:
{
    home.packages = with pkgs; [
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.lightly
    ];
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gtk";
  };
  # qt = {
  #   enable = true;
  #   platformTheme = "qt5ct";
  #   style = {
  #     package = pkgs.catppuccin-kvantum;
  #     name = "kvantum";
  #   };
  # };
}
