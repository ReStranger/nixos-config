{ username, ... }:
let
  settings = {
    hyprland = {
      monitor = [ "eDP-1, 1920x1080@60, 0x0, 1.25" ];

      workspace = [
        "1,monitor:eDP-1,default:true"
        "2,monitor:eDP-1"
        "3,monitor:eDP-1"
        "4,monitor:eDP-1"
        "5,monitor:eDP-1"
        "6,monitor:eDP-1"
        "7,monitor:eDP-1"
      ];
    };
  };
in
{
  home-manager.users.${username}.wayland.windowManager = {
    hyprland.settings = settings.hyprland;
  };
}
