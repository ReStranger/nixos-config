{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:

let
  cfg = config.module.programs.hyprland;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.programs.hyprland.enable = mkEnableOption "Enables hyprland";
  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };
    services.libinput.enable = true;
  };
}
