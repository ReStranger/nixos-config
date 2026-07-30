{
  workspace_rule = [
    {
      workspace = "w[tv1]";
      gaps_out = 0;
      gaps_in = 0;
    }
    {
      workspace = "f[1]";
      gaps_out = 0;
      gaps_in = 0;
    }
  ];

  window_rule = [
    {
      name = "workspace-1-pin-browser";
      match = {
        class = "^zen-beta$";
      };
      workspace = "1 silent";
    }
    {
      name = "workspace-2-pin-obsidian";
      match = {
        class = "^obsidian$";
      };
      workspace = "2 silent";
    }
    {
      name = "workspace-3-pin-discord";
      match = {
        class = "^discord$";
      };
      workspace = "3 silent";
    }
    {
      name = "workspace-3-pin-ayugram";
      match = {
        class = "^com.ayugram.desktop$";
      };
      workspace = "3 silent";
    }
    {
      name = "workspace-5-pin-steam-update";
      match = {
        initial_title = "^Steam$";
      };
      workspace = "5 silent";
    }
    {
      name = "workspace-5-steam";
      match = {
        class = "^steam$";
      };
      workspace = "5 silent";
    }

    {
      name = "no-gaps-wtv1";
      match = {
        float = false;
        workspace = "w[tv1]";
      };
      border_size = 0;
      rounding = 0;
    }
    {
      name = "no-gaps-f1";
      match = {
        float = false;
        workspace = "f[1]";
      };
      border_size = 0;
      rounding = 0;
    }

    {
      name = "global-transparency";
      match = {
        class = ".*";
      };
      opacity = "0.89 override 0.89 override";
    }
    {
      name = "disable-transparency-in-fullscreen";
      match = {
        fullscreen = true;
      };
      opacity = "1.0 override 1.0 override";
    }
    {
      name = "disable-transparency-in-terminal";
      match = {
        class = "^com.mitchellh.ghostty$";
      };
      opacity = "1.0 override 1.0 override";
    }

    {
      name = "fix-xwayland-drags";
      match = {
        class = "^$";
        title = "^$";
        xwayland = true;
        float = true;
        fullscreen = false;
        pin = false;
      };
      no_focus = true;
    }

    {
      match = {
        class = "cs2";
      };
      immediate = true;
    }

    {
      name = "portal-filepicker";
      match = {
        class = "^org.freedesktop.impl.portal.desktop.kde$";
        title = "^Открытие файлов$";
      };
      size = "1230 730";
      float = true;
      fullscreen = false;
      center = true;
    }

    {
      name = "picture-in-picture-in-zen-beta";
      match = {
        class = "^zen-beta$";
        title = "^Picture-in-Picture$";
      };
      workspace = "[w]";
      float = true;
      size = "427 277";
      border_size = 0;
      pin = true;
    }
  ];
}
