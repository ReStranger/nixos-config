{
  lib,
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
    };
    services.libinput.enable = true;
  };
}
