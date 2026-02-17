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
    mkOption
    mkIf
    mkDefault
    optionals
    ;
  inherit (lib.types) enum;
  terminal = "wezterm";
  fileManager = "nautilus -w";
  menu = "anyrun";
in
{
  imports = [
    "${self}/home/modules/hyprland/variables"
    "${self}/home/modules/hyprland/styles"
  ];
  options.module.hyprland = {
    enable = mkEnableOption "Enable Hyprland";
    style = mkOption {
      type = enum [
        "round"
        "flat"
      ];
      default = "round";
      description = "Set Hyprland style";
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile."uwsm/env".source =
      "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
    module.hyprland = {
      variables.enable = mkDefault true;
      styles.round.enable = cfg.style == "round";
      styles.flat.enable = cfg.style == "flat";
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

        exec-once = map (cmd: "uwsm app -- ${cmd}") [
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
          layout = "dwindle";
          allow_tearing = true;
        };

        decoration = {
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
        layerrule = [
          "match:namespace anyrun, no_anim on"
          "match:namespace quickshell:.*, blur_popups on"
          "match:namespace quickshell:.*, blur on"
          "match:namespace quickshell:.*, ignore_alpha 0.5"
        ];

        workspace = [
          "w[t1], gapsout:0, gapsin:0"
          "w[tg1], gapsout:0, gapsin:0"
          "f[1], gapsout:0, gapsin:0"
        ];

        windowrule = [
          {
            name = "workspace-1-pin-browser";
            "match:class" = "zen-beta";
            workspace = "1 silent";
          }
          {
            name = "workspace-2-pin-obsidian";
            "match:class" = "obsidian";
            workspace = "2 silent";
          }
          {
            name = "workspace-3-pin-discord";
            "match:class" = "discord";
            workspace = "3 silent";
          }
          {
            name = "workspace-3-pin-ayugram";
            "match:class" = "com.ayugram.desktop";
            workspace = "3 silent";
          }
          {
            name = "workspace-5-pin-steam-update";
            "match:initial_title" = "Steam";
            workspace = "5 silent";
          }
          {
            name = "workspace-5-steam";
            "match:class" = "steam";
            workspace = "5 silent";
          }

          # Saving a file in в zen-beta # FIXME:
          {
            name = "saving-a-picture-in-zen-beta";
            "match:title" = "Сохранение изображения.*";
            "match:class" = "xdg-desktop-portal-gtk";
            size = "900 590";
            center = "on";
            # workspace = "[w]";
          }
          {
            name = "saving-a-file-in-zen-beta";
            "match:class" = "zen-beta";
            "match:title" = "Введите имя файла для сохранения…";
            workspace = "[w]";
            size = "900 590";
            center = "on";
          }
          {
            name = "picture-in-picture-in-zen-beta";
            "match:class" = "zen-beta";
            "match:title" = "Картинка в картинке";
            workspace = "[w]";
            float = "on";
            size = "427 277";
            pin = "on";
          }
          {
            name = "viewing-media-in-telegram";
            "match:class" = "com.ayugram.desktop";
            "match:title" = "Просмотр медиа";
            workspace = "[w]";
            center = "on";
            float = "on";
          }
          {
            name = "screensharing-popup";
            "match:title" = "Select what to share";
            size = "500 290";
            float = "on";
          }

          {
            name = "Calculator";
            "match:class" = "org.gnome.Calculator";
            size = "334 494";
            float = "on";
            pin = "on";
          }
          {
            name = "clock";
            "match:class" = "org.gnome.clocks";
            size = "600 730";
            float = "on";
          }
          {
            name = "eog-popup";
            "match:class" = "eog";
            size = "960 540";
            center = "on";
          }

          {
            name = "polkit-popup";
            "match:class" = "polkit-gnome-authentication-agent-1";
            workspace = "[w]";
          }
          {
            name = "global-transparency";
            "match:class" = ".*";
            opacity = "0.89 override 0.89 override";
          }
          {
            name = "disable-transparency-in-fullscreen";
            "match:fullscreen" = true;
            opacity = "1.0 override 1.0 override";
          }
          {
            name = "disable-transparency-in-terminal";
            "match:class" = "org.wezfurlong.wezterm";
            opacity = "1.0 override 1.0 override";
          }

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
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = if i < 9 then i + 1 else 10;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
            ]
          ) 10
        ));
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
