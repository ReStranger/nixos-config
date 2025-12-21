{
  self,
  lib,
  config,
  pkgs,
  inputs,
  isLaptop,
  username,
  ...
}:
let
  cfg = config.module.hyprland;
  inherit (lib)
    mkEnableOption
    mkIf
    mkDefault
    optionals
    ;
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
    xdg.configFile."uwsm/env".source =
      "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
    module.hyprland = {
      variables.enable = mkDefault cfg.enable;
    };
    dconf.settings."org/gnome/desktop/wm/preferences" = {
      button-layout = "";
    };
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      xwayland.enable = true;
      systemd.enable = false;
      plugins = [
        inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.csgo-vulkan-fix
      ];
      settings = {
        ecosystem = {
          no_update_news = true;
        };

        exec-once = builtins.map (cmd: "uwsm app -- ${cmd}") [
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          "swww-daemon"
          "swww img /home/${username}/.config/hypr/wallpaper --transition-type center"
        ];
        exec = [ ];

        input = {
          kb_layout = "us,ru";
          kb_model = "pc105+inet";
          kb_options = "grp:alt_shift_toggle";
          numlock_by_default = true;

          follow_mouse = 1;

          touchpad = {
            middle_button_emulation = isLaptop;
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

        gesture = mkIf isLaptop [
          "3, horizontal, workspace"
          "3, vertical, special, magic"
        ];

        misc = {
          force_default_wallpaper = 0;
          middle_click_paste = false;
          enable_anr_dialog = false;
        };

        plugin = {
          csgo-vulkan-fix = {
            fix_mouse = true;
            vkfix-app = "cs2, 1440, 1080";
          };
        };

        xwayland = {
          force_zero_scaling = true;
        };

        workspace = [
          "w[t1], gapsout:0, gapsin:0"
          "w[tg1], gapsout:0, gapsin:0"
          "f[1], gapsout:0, gapsin:0"
        ];

        windowrule = [
          "workspace 1 silent, match:class ^(zen-beta)$"
          "workspace 2 silent, match:class ^(obsidian)$"
          "workspace 3 silent, match:class ^(discord)$"
          "workspace 3 silent, match:class ^(com.ayugram.desktop)$"
          "workspace 5 silent, match:initial_title ^(Steam)$"
          "workspace 5 silent, match:class ^(steam)$"

          # Saving a file in в zen-beta
          "workspace [w], match:title ^(Сохранение изображения)$, match:class ^(zen-beta)$"
          "size 900 590, match:title ^(Сохранение изображения)$, match:class ^(zen-beta)$"
          "center on, match:title ^(Сохранение изображения)$, match:class ^(zen-beta)$"

          "workspace [w], match:title ^(Введите имя файла для сохранения…)$, match:class ^(zen-beta)$"
          "size 900 590, match:title ^(Введите имя файла для сохранения…)$, match:class ^(zen-beta)$"
          "center on, match:title ^(Введите имя файла для сохранения…)$, match:class ^(zen-beta)$"

          # Picture in picture in zen-beta
          "workspace [w], match:class ^(zen-beta)$, match:title ^(Картинка в картинке)$"
          "float on,match:class ^(zen-beta)$, match:title ^(Картинка в картинке)$"
          "size 427 277,match:class ^(zen-beta)$, match:title ^(Картинка в картинке)$"
          "pin on,match:class ^(zen-beta)$, match:title ^(Картинка в картинке)$"

          # Viewing media в telegram
          "workspace [w], match:title ^(Просмотр медиа)$, match:class ^(com.ayugram.desktop)$"
          "center on, match:title ^(Просмотр медиа)$, match:class ^(com.ayugram.desktop)$"
          "float on, match:title ^(Просмотр медиа)$, match:class ^(com.ayugram.desktop)$"

          # Fix screensharing popup
          "workspace [w], match:class ^(hyprland-share-picker)$, match:title ^(MainPicker)$"
          "float on, match:class ^(hyprland-share-picker)$, match:title ^(MainPicker)$"
          "size 500 290, match:class ^(hyprland-share-picker)$, match:title ^(MainPicker)$"

          # Calculator
          "float on, match:class ^(org.gnome.Calculator)$, match:title ^(Калькулятор)$"
          "size 334 494, match:class ^(org.gnome.Calculator)$, match:title ^(Калькулятор)$"
          "pin on, match:class ^(org.gnome.Calculator)$, match:title ^(Калькулятор)$"

          # Clocks
          "float on, match:class ^(org.gnome.clocks)$, match:title ^(Часы)$"
          "size 600 730, match:class ^(org.gnome.clocks)$, match:title ^(Часы)$"

          # Popup eog
          "float on,match:class ^(eog)$"
          "size 960 540,match:class ^(eog)$"
          "center on,match:class ^(eog)$"

          # Fix polkit popup
          "workspace [w], match:class ^(polkit-gnome-authentication-agent-1)$"

          "opacity 0.89 override 0.89 override, match:class .*"
          "opacity 1.0 override 1.0 override, match:fullscreen true"
          "opacity 1.0 override 1.0 override, match:class ^(org.wezfurlong.wezterm)$"

          "border_size 0, match:float false, match:workspace w[t1]"
          "rounding 0, match:float false, match:workspace w[t1]"
          "border_size 0, match:float false, match:workspace w[tg1]"
          "rounding 0, match:float false, match:workspace w[tg1]"
          "border_size 0, match:float false, match:workspace f[1]"
          "rounding 0, match:float false, match:workspace f[1]"
        ];

        "$mod" = "SUPER";
        bind = [
          "$mod, T, exec, uwsm app -- ${terminal}"
          "$mod, Q, killactive,"
          "$mod SHIFT, Q, forcekillactive"
          "$mod, E, exec, uwsm app -- ${fileManager}"
          "$mod, D, exec, uwsm app -- ${menu}"
          "CTRL, Print, exec, uwsm app -- grimblast --notify --freeze copy area"
          "CTRL SHIFT, Print, exec, uwsm app -- grimblast --notify --freeze copysave area $HOME/Pictures/Screenshots/$(date '+%Y-%m-%d--%H-%M-%S')-screenshot.png"

          "$mod ALT, R, exec, hyprctl reload"

          "$mod, R, togglesplit, # dwindle"
          "$mod SHIFT, F, togglefloating, "
          "$mod, F, fullscreen,"
          "$mod SHIFT, P, pseudo, # dwindle"

          "$mod, C, exec, uwsm app -- hyprpicker --autocopy"

          "ALT, F10, pass, class:^(com.obsproject.Studio)$"
          "CTRL SHIFT, M, pass, class:^(discord)$"

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

        ]
        ++ optionals isLaptop [
          "$mod, Control_L, movewindow"
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
