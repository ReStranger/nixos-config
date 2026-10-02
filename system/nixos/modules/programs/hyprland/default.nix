{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.module.programs.hyprland;
  inherit (lib) mkEnableOption mkIf;
in {
  options.module.programs.hyprland.enable = mkEnableOption "Enables hyprland";
  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };
    services.libinput.enable = true;
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config.common.default = ["hyprland" "kde"];
      extraPortals = [
        (pkgs.kdePackages.xdg-desktop-portal-kde.override {
          mkKdeDerivation = args:
            pkgs.kdePackages.mkKdeDerivation (args
              // {
                excludeDependencies = ["plasma-workspace"];
              });
        })
      ];
    };
    # HACK
    environment.etc."xdg/menus/hyprland-applications.menu".source = ./dolphin.menu;
  };
}
