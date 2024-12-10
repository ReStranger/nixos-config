{ config, lib, hostname, ... }:

with lib;

let
  cfg = config.module.hyprland.monitors;

  commonMonitorSettings = [ ", preferred, auto, 1" ];

  hostSpecificMonitorSettings = if hostname == "pc" then
    [
      "HDMI-A-1, 1920x1080@75, 0x0, 1"
      "DVI-D-1,disable"
    ]
  else if hostname == "magicbook" then
    [
      "eDP-1, 1920x1080@60, 0x0, 1.25"
    ]
  else
    [ ];

  monitorsSettings = commonMonitorSettings ++ hostSpecificMonitorSettings;

  commonWorkspacesSettings = [ ];

  hostSpecificWorkspacesSettings = if hostname == "pc" then
    [
      "1,monitor:HDMI-A-1,default:true"
      "2,monitor:HDMI-A-1"
      "3,monitor:HDMI-A-1"
      "4,monitor:HDMI-A-1"
      "5,monitor:HDMI-A-1"
      "6,monitor:HDMI-A-1"
      "7,monitor:DVI-D-1,default:true"
      "8,monitor:DVI-D-1"
      "9,monitor:DVI-D-1"
      "0,monitor:DVI-D-1"
    ]
  else if hostname == "magicbook" then
    [
      "1,monitor:eDP-1,default:true"
      "2,monitor:eDP-1"
      "3,monitor:eDP-1"
      "4,monitor:eDP-1"
      "5,monitor:eDP-1"
      "6,monitor:eDP-1"
      "7,monitor:eDP-1"
    ]
  else
    [ ];

  workspacesSettings = commonWorkspacesSettings ++ hostSpecificWorkspacesSettings;

in
{
  options = {
    module.hyprland.monitors.enable = mkEnableOption "Enable monitors in Hyprland";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      monitor = monitorsSettings;
      workspace = workspacesSettings;
    };
  };
}
