{username, ...}: let
  settings = {
    fontSize = 10;
    hyprland = {
      monitor = [
        {
          output = "HDMI-A-2";
          mode = "1920x1080@75";
          position = "0x0";
          scale = "1.0";
        }
      ];

      workspace_rule = [
        {
          workspace = 1;
          monitor = "HDMI-A-2";
          default = true;
        }
        {
          workspace = 2;
          monitor = "HDMI-A-2";
        }
        {
          workspace = 3;
          monitor = "HDMI-A-2";
        }
        {
          workspace = 4;
          monitor = "HDMI-A-2";
        }
        {
          workspace = 5;
          monitor = "HDMI-A-2";
        }
        {
          workspace = 6;
          monitor = "HDMI-A-2";
        }
        {
          workspace = 7;
          monitor = "HDMI-A-2";
        }
        {
          workspace = 8;
          monitor = "HDMI-A-2";
        }
        {
          workspace = 9;
          monitor = "HDMI-A-2";
        }
        {
          workspace = 0;
          monitor = "HDMI-A-2";
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
