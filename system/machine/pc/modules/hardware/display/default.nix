{ username, ... }:
let
  settings = {
    fontSize = 10;
    hyprland = {
      monitor = [ "HDMI-A-1, 1920x1080@75, 0x0, 1" ];

      workspace = [
        "1,monitor:HDMI-A-1,default:true"
        "2,monitor:HDMI-A-1"
        "3,monitor:HDMI-A-1"
        "4,monitor:HDMI-A-1"
        "5,monitor:HDMI-A-1"
        "6,monitor:HDMI-A-1"
        "7,monitor:HDMI-A-1"
        "8,monitor:HDMI-A-1"
        "9,monitor:HDMI-A-1"
        "0,monitor:HDMI-A-1"
      ];
    };
  };
in
{
  stylix.fonts.sizes = with settings; {
    applications = fontSize;
    terminal = fontSize;
    popups = fontSize;
    desktop = fontSize;
  };
  home-manager.users.${username}.wayland.windowManager = {
    hyprland.settings = settings.hyprland;
  };
}
