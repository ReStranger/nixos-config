{ osConfig, ... }:
{
  wayland.windowManager.hyprland.settings = 
    if ( osConfig.networking.hostname == "pc") then
      {
        monitor = [
          "HDMI-A-1, 1920x1080@75, 0x0, 1"
          # "DVI-D-1, 1366x768@60, 1920x220, 1"
          "DVI-D-1,disable"
        ];
      }
    else if ( osConfig.networking.hostname == "magicbook" ) then 
      {
        monitor = [
          "HDMI-A-1, 1920x1080@75, 0x0, 1"
          # "DVI-D-1, 1366x768@60, 1920x220, 1"
          "DVI-D-1,disable"
        ];
      }
    else
      {
        monitor = ", preferred, auto, 1";
      };
}
