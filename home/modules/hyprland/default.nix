{
  self,
  lib,
  config,
  pkgs,
  hostname,
  username,
  ...
}:
let
  cfg = config.module.hyprland;
  inherit (lib) mkEnableOption mkIf mkDefault;
  terminal = "wezterm";
  fileManager = "nautilus -w";
  menu = "anyrun";
in
{
  imports = [
    "${self}/home/modules/hyprland/variables"
  ];
  options.module.hyprland.enable = mkEnableOption "Enable Hyprland";

  config = mkIf cfg.enable {
    module.hyprland = {
      variables.enable = mkDefault cfg.enable;
    };
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config.common.default = "gtk";
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
    dconf.settings."org/gnome/desktop/wm/preferences" = {
      button-layout = "";
    };
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
      settings = {
        ecosystem = {
          no_update_news = true;
        };
        exec-once = [
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          "swww-daemon"
          "swww img /home/${username}/.config/hypr/wallpaper --transition-type center"
          "qs"
          "kidex"
          "bash /home/${username}/.config/nwg-dock-hyprland/nwg-dock"
        ];
        exec =
          if hostname == "pc" then
            [
              "alsactl init"
              "pactl set-default-sink alsa_output.pci-000_0a_00.4.analog-stereo"
              "pactl set-sink-volume alsa_output.pci-0000_0a_00.4.analog-stereo 50%"
              "pactl set-source-volume alsa_input.pci-0000_0a_00.4.analog-stereo 35%"
            ]
          else
            [ ];
        input = {
          kb_layout = "us,ru";
          kb_model = "pc105+inet";
          kb_options = "grp:alt_shift_toggle";
          numlock_by_default = true;

          follow_mouse = 1;

          touchpad = {
            middle_button_emulation = if hostname == "magicbook" then true else false;
            natural_scroll = true;
          };

          sensitivity = 0;
          accel_profile = "flat";
        };
        device = {
          name = "2.4g-2.4g-wireless-device-mouse";
          sensitivity = 0;
          accel_profile = "flat";
        };

        general = {

          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;

          layout = "dwindle";

          allow_tearing = true;
        };
        decoration = {
          rounding = 15;
          shadow = {
            enabled = true;
            range = 30;
            offset = "2 3";
            render_power = 3;
          };
          blur = {
            enabled = true;
            size = 14;
            passes = 3;
            brightness = 1;
            noise = 0.01;
            contrast = 1;
            popups = true;
            popups_ignorealpha = 0.6;
            input_methods = true;
            input_methods_ignorealpha = 0.8;
            new_optimizations = true;
            ignore_opacity = true;
            xray = false;
            special = false;
          };
          layerrule = [
            "blur,rofi"
            "ignorealpha [1],rofi"
          ];
          dim_inactive = false;
        };

        animations = {
          enabled = true;

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        master = {
          new_status = "master";
        };
        gesture = [
            "3, horizontal, workspace"
            "3, vertical, special, magic"
        ];
        misc = {
          force_default_wallpaper = 0;
          middle_click_paste = false;
          enable_anr_dialog = false;
        };
        xwayland = {
          force_zero_scaling = true;
        };
        workspace = [
          "w[t1], gapsout:0, gapsin:0"
          "w[tg1], gapsout:0, gapsin:0"
          "f[1], gapsout:0, gapsin:0"
        ];

        windowrulev2 = [
          "workspace 1 silent, class:^(zen-beta)$"
          "workspace 2 silent, class:^(obsidian)$"
          "workspace 3 silent, class:^(discord)$"
          "workspace 3 silent, class:^(com.ayugram.desktop)$"
          "workspace 5 silent, title:^(Spotify Free)$"
          "workspace 3 silent, class:^(com.ayugram.desktop)$"

          #Сохранение файла в zen-beta
          "workspace [w], title:^(Save Image)$, class:^(zen-beta)$"
          "size 900 590, itle:^(Save Image)$, class:^(zen-beta)$"
          "center, title:^(Save Image)$, class:^(zen-beta)$"

          "workspace [w], title:^(Enter name of file to save to…)$, class:^(zen-beta)$"
          "size 900 590, itle:^(Enter name of file to save to…)$, class:^(zen-beta)$"
          "center, title:^(Enter name of file to save to…)$, class:^(zen-beta)$"

          # Просмотр медиа в telegram
          "workspace [w], title:^(Просмотр медиа)$, class:^(com.ayugram.desktop)$"
          "center, title:^(Просмотр медиа)$, class:^(com.ayugram.desktop)$"
          "float, title:^(Просмотр медиа)$, class:^(com.ayugram.desktop)$"

          #Сохранение файла в vesktop
          "workspace [w], class:^(Electron)$, title:^(.*blob.*)$"
          "float, class:^(Electron)$, title:^(.*blob.*)$"
          "size 900 590, class:^(Electron)$, title:^(.*blob.*)$"
          "center, class:^(Electron)$, title:^(.*blob.*)$"

          # Отправка файла в vesktop
          "workspace [w], class:^(Electron)$, title:^(Открытие файлов)$"
          "float, class:^(Electron)$, title:^(Открытие файлов)$ "
          "size 900 590, class:^(Electron)$, title:^(Открытие файлов)$ "
          "center, class:^(Electron)$, title:^(Открытие файлов)$"

          # Fix sharing video
          "workspace [w], class:^(hyprland-share-picker)$, title:^(MainPicker)$"
          "float, class:^(hyprland-share-picker)$, title:^(MainPicker)$"
          "size 500 290, class:^(hyprland-share-picker)$, title:^(MainPicker)$"

          # Картинка в картинке в zen-beta

          # ru_RU-UTF-8
          "workspace [w], class:^(zen-beta)$, title:^(Картинка в картинке)$"
          "float,class:^(zen-beta)$, title:^(Картинка в картинке)$"
          "size 427 277,class:^(zen-beta)$, title:^(Картинка в картинке)$"
          "pin,class:^(zen-beta)$, title:^(Картинка в картинке)$"
          # en_US-UTF-8
          "workspace [w], class:^(zen-beta)$, title:^(Picture-in-Picture)$"
          "float,class:^(zen-beta)$, title:^(Picture-in-Picture)$"
          "size 427 277,class:^(zen-beta)$, title:^(Picture-in-Picture)$"
          "pin,class:^(zen-beta)$, title:^(Picture-in-Picture)$"

          "workspace [w], class:^(org.pulseaudio.pavucontrol)$, title:^(Громкость)$"

          # Calculator
          "float, class:^(org.gnome.Calculator)$, title:^(Калькулятор)$"
          "size 334 494, class:^(org.gnome.Calculator)$, title:^(Калькулятор)$"
          "pin, class:^(org.gnome.Calculator)$, title:^(Калькулятор)$"
          "workspace [w], class:^(polkit-gnome-authentication-agent-1)$"

          # Popup imv
          "float,class:^(imv)$"
          "size 960 540,class:^(imv)$"
          "center,class:^(imv)$"

          # Fix xwayland
          "noblur,class:^()$,class:^()$"
          "nofocus,class:^(kstudy.exe)$,class:^(RoamingWindow)$"
          "noshadow,class:^(kstudy.exe)$,class:^(RoamingWindow)$"
          "noborder,class:^(kstudy.exe)$,class:^(RoamingWindow)$"
          "float,class:^(kstudy.exe)$,class:^(RoamingWindow)$"

          "opacity 0.89 override 0.89 override, class:.*"
          "opacity 1.0 override 1.0 override, fullscreen:1"

          "bordersize 0, floating:0, onworkspace:w[t1]"
          "rounding 0, floating:0, onworkspace:w[t1]"
          "bordersize 0, floating:0, onworkspace:w[tg1]"
          "rounding 0, floating:0, onworkspace:w[tg1]"
          "bordersize 0, floating:0, onworkspace:f[1]"
          "rounding 0, floating:0, onworkspace:f[1]"
        ];

        "$mod" = "SUPER";
        bind = [
          "$mod, T, exec, ${terminal}"
          "$mod, Q, killactive,"
          "$mod SHIFT, Q, forcekillactive"
          "$mod, E, exec, ${fileManager}"
          "$mod, D, exec, ${menu}"
          "CTRL, Print, exec, grimblast --notify --freeze copy area"
          "CTRL SHIFT, Print, exec, grimblast --notify --freeze copysave area $HOME/Pictures/Screenshots/$(date '+%Y-%m-%d--%H-%M-%S')-screenshot.png"

          "$mod ALT, R, exec, hyprctl reload"
          "$mod ALT, W, exec, ags quit; ags run"

          "$mod, R, togglesplit, # dwindle"
          "$mod SHIFT, F, togglefloating, "
          "$mod, F, fullscreen,"
          "$mod SHIFT, P, pseudo, # dwindle"

          "$mod, C, exec, hyprpicker --autocopy"
          "$mod ALT, O, exec, firefox & obsidian & ayugram-desktop -- %u & discord & spotify & pactl set-default-sink alsa_output.pci-0000_0a_00.4.analog-stereo"
          "$mod ALT, P, exec, ags -t powermenu"

          "$mod, L, movefocus, r"
          "$mod, H, movefocus, l"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"

          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"

          "$mod SHIFT, 1, movetoworkspacesilent, 1"
          "$mod SHIFT, 2, movetoworkspacesilent, 2"
          "$mod SHIFT, 3, movetoworkspacesilent, 3"
          "$mod SHIFT, 4, movetoworkspacesilent, 4"
          "$mod SHIFT, 5, movetoworkspacesilent, 5"
          "$mod SHIFT, 6, movetoworkspacesilent, 6"
          "$mod SHIFT, 7, movetoworkspacesilent, 7"
          "$mod SHIFT, 8, movetoworkspacesilent, 8"
          "$mod SHIFT, 9, movetoworkspacesilent, 9"
          "$mod SHIFT, 0, movetoworkspacesilent, 10"

          "$mod SHIFT, H, swapwindow, l"
          "$mod SHIFT, L, swapwindow, r"
          "$mod SHIFT, K, swapwindow, u"
          "$mod SHIFT, J, swapwindow, d"

          "$mod CTRL, H, resizeactive, -20 0"
          "$mod CTRL, L, resizeactive, 20 0"
          "$mod CTRL, K, resizeactive, 0 -20"
          "$mod CTRL, J, resizeactive, 0 20"

          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"

          "$mod, mouse_down, workspace, e-1"
          "$mod, mouse_up, workspace, e+1"
        ];
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"

          "$mod, Control_L, movewindow"
          "$mod, mouse:273, resizewindow"
          "$mod, ALT_L, resizewindow"
        ];
        bindel = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
          ", XF86MonBrightnessDown, exec, brightnessctl set 5++%-"
        ];
        bindl = [
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86AudioNext, exec, playerctl next"
        ];
      };
    };
  };
}
