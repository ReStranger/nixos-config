{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:

let
  cfg = config.module.programs.hyprland;
  pkg = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.programs.hyprland.enable = mkEnableOption "Enables hyprland";
  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
      package = pkg.hyprland;
      portalPackage = pkg.xdg-desktop-portal-hyprland;
    };
    services.libinput.enable = true;
    programs.uwsm.waylandCompositors.hyprland.binPath =
      lib.mkForce "/run/current-system/sw/bin/start-hyprland";
  };
}
