{username, ...}: let
  settings = {
    fontSize = 12;
    hyprland = {
      monitor = [
        {
          output = "eDP-1";
          mode = "1920x1080@60";
          position = "0x0";
          scale = "1.25";
        }
        {
          output = "HDMI-A-1";
          mode = "1920x1080@60";
          position = "0x-720";
          scale = "1.5";
        }
      ];
      workspace_rule = [
        {
          workspace = 1;
          monitor = "eDP-1";
          default = true;
        }
        {
          workspace = 2;
          monitor = "eDP-1";
        }
        {
          workspace = 3;
          monitor = "eDP-1";
        }
        {
          workspace = 4;
          monitor = "eDP-1";
        }
        {
          workspace = 5;
          monitor = "eDP-1";
        }
        {
          workspace = 6;
          monitor = "eDP-1";
        }
        {
          workspace = 7;
          monitor = "HDMI-A-1";
          default = true;
        }
        {
          workspace = 8;
          monitor = "HDMI-A-1";
        }
        {
          workspace = 9;
          monitor = "HDMI-A-1";
        }
        {
          workspace = 0;
          monitor = "HDMI-A-1";
        }
      ];
    };
  };
in {
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
