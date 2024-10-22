{ inputs
, pkgs
, lib
, config
, ...
}:

with lib;

let
  cfg = config.module.programs.hyprland;
in {
  options = {
    module.programs.hyprland.enable = mkEnableOption "Enables hyprland";
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
      wayland.enable = true;
    };
    services.libinput.enable = true;
  };
}
