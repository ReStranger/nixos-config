{
  self,
  lib,
  config,
  pkgs,
  inputs,
  isLaptop,
  ...
}: let
  cfg = config.module.hyprland;
  inherit
    (lib)
    mkEnableOption
    mkOption
    mkIf
    mkDefault
    mkForce
    optionals
    ;
  inherit (lib.types) enum;
  terminal = "${inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/ghostty";
  fileManager = "${pkgs.nautilus}/bin/nautilus -w";
  menu = "${inputs.anyrun.packages.${pkgs.stdenv.hostPlatform.system}.anyrun}/bin/anyrun";
in {
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
    xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
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
      configType = "lua";
      plugins = [
        inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.csgo-vulkan-fix
      ];
      settings = {
        monitor = [
          {
            output = "";
            mode = "preferred";
            position = "auto";
            scale = "auto";
          }
        ];

        on = {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''
              function()
                hl.exec_cmd("uwsm app -- ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1")
              end
            '')
          ];
        };
        config = {
          general = {
            resize_on_border = false;
            allow_tearing = true;
            layout = "dwindle";
          };

          decoration = {
            shadow = {
              color = "rgba(12121499)";
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
          };

          animations = {
            enabled = true;
          };

          dwindle = {
            preserve_split = true; # You probably want this
          };

          master = {
            new_status = "master";
          };

          scrolling = {
            fullscreen_on_one_column = true;
          };

          misc = {
            force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
            middle_click_paste = false;
            enable_anr_dialog = false;
            disable_hyprland_logo = true; # If true disables the random hyprland logo / anime girl background. :(
          };

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

          ecosystem = {
            no_update_news = true;
            # enforce_permissions = true;
          };
        };

        gesture = mkIf isLaptop [
          {
            fingers = 3;
            direction = "horizontal";
            action = "workspace";
          }
          {
            fingers = 3;
            direction = "vertical";
            action = "special";
            name = "magic";
          }
        ];

        device = {
          name = "2.4g-2.4g-wireless-device-mouse";
          sensitivity = 0;
          accel_profile = "flat";
        };

        curve = [
          {
            _args = [
              "myBezier"
              {
                type = "bezier";
                points = [
                  [0.05 0.9]
                  [0.1 1.05]
                ];
              }
            ];
          }
        ];

        animation = [
          {
            leaf = "border";
            enabled = true;
            speed = 10;
            bezier = "default";
          }
          {
            leaf = "borderangle";
            enabled = true;
            speed = 8;
            bezier = "default";
          }
          {
            leaf = "windows";
            enabled = true;
            speed = 7;
            bezier = "myBezier";
          }
          {
            leaf = "windowsOut";
            enabled = true;
            speed = 7;
            bezier = "default";
            style = "popin 80%";
          }
          {
            leaf = "fade";
            enabled = true;
            speed = 7;
            bezier = "default";
          }
          {
            leaf = "workspaces";
            enabled = true;
            speed = 6;
            bezier = "default";
          }
        ];

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
              class = "^zen%-beta$";
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
              class = "^com%.ayugram%.desktop$";
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
            name = "saving-a-picture-in-zen-beta";
            match = {
              title = "Сохранение изображения.*";
              class = "^xdg%-desktop%-portal%-gtk$";
            };
            size = "900 590";
            center = true;
            float = true;
          }
          {
            name = "saving-a-file-in-zen-beta";
            match = {
              class = "^zen%-beta$";
              title = "^Введите имя файла для сохранения…$";
            };
            workspace = "[w]";
            size = "900 590";
            center = true;
          }
          {
            name = "picture-in-picture-in-zen-beta";
            match = {
              class = "^zen%-beta$";
              title = "^Картинка в картинке$";
            };
            workspace = "[w]";
            float = true;
            size = "427 277";
            border_size = 0;
            pin = true;
          }
          {
            name = "viewing-media-in-telegram";
            match = {
              class = "^com%.ayugram%.desktop$";
              title = "^Просмотр медиа$";
            };
            workspace = "[w]";
            center = true;
            float = true;
          }
          {
            name = "screensharing-popup";
            match = {
              title = "^Select what to share$";
            };
            size = "500 290";
            float = true;
          }
          {
            name = "calculator";
            match = {
              class = "^org%.gnome%.Calculator$";
            };
            size = "360 620";
            float = true;
            pin = true;
          }
          {
            name = "clock";
            match = {
              class = "^org%.gnome%.clocks$";
            };
            size = "500 629";
            float = true;
          }
          {
            name = "eog-popup";
            match = {
              class = "^org%.gnome%.eog$";
            };
            float = true;
            size = "960 540";
            center = true;
          }
          {
            name = "polkit-popup";
            match = {
              class = "^polkit%-gnome%-authentication%-agent%-1$";
            };
            workspace = "[w]";
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
              class = "^org%.wezfurlong%.wezterm$";
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
        ];
        bind = let
          mainMod = "SUPER";
        in
          [
            # Launchers
            {
              _args = [
                "${mainMod} + T"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"uwsm app -- ${terminal}\")")
              ];
            }
            {
              _args = [
                "${mainMod} + Q"
                (lib.generators.mkLuaInline "hl.dsp.window.close()")
              ];
            }
            {
              _args = [
                "${mainMod} + SHIFT + Q"
                (lib.generators.mkLuaInline "hl.dsp.window.close({ force = true })")
              ];
            }
            {
              _args = [
                "${mainMod} + E"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"uwsm app -- ${fileManager}\")")
              ];
            }
            {
              _args = [
                "${mainMod} + D"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"uwsm app -- ${menu}\")")
              ];
            }
            {
              _args = [
                "${mainMod} + C"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"uwsm app -- ${pkgs.hyprpicker}/bin/hyprpicker --autocopy\")")
              ];
            }
            {
              _args = [
                "${mainMod} + ALT + R"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"hyprctl reload\")")
              ];
            }

            # Window state
            {
              _args = [
                "${mainMod} + R"
                (lib.generators.mkLuaInline "hl.dsp.layout(\"togglesplit\")")
              ];
            }
            {
              _args = [
                "${mainMod} + SHIFT + F"
                (lib.generators.mkLuaInline "hl.dsp.window.float({ action = \"toggle\" })")
              ];
            }
            {
              _args = [
                "${mainMod} + F"
                (lib.generators.mkLuaInline "hl.dsp.window.fullscreen()")
              ];
            }
            {
              _args = [
                "${mainMod} + SHIFT + P"
                (lib.generators.mkLuaInline "hl.dsp.window.pseudo()")
              ];
            }

            # Clipboard / screenshots
            {
              _args = [
                "CTRL + Print"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"uwsm app -- ${pkgs.grimblast}/bin/grimblast --notify --freeze copy area\")")
              ];
            }
            {
              _args = [
                "CTRL + SHIFT + Print"
                (lib.generators.mkLuaInline ''
                  hl.dsp.exec_cmd(
                    "uwsm app -- ${pkgs.grimblast}/bin/grimblast --notify --freeze copysave area $HOME/Pictures/Screenshots/$(date '+%Y-%m-%d--%H-%M-%S')-screenshot.png"
                  )
                '')
              ];
            }
            {
              _args = [
                "${mainMod} + L"
                (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"right\" })")
              ];
            }
            {
              _args = [
                "${mainMod} + H"
                (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"left\" })")
              ];
            }
            {
              _args = [
                "${mainMod} + K"
                (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"up\" })")
              ];
            }
            {
              _args = [
                "${mainMod} + J"
                (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"down\" })")
              ];
            }

            # Window swap
            {
              _args = [
                "${mainMod} + SHIFT + H"
                (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"left\" })")
              ];
            }
            {
              _args = [
                "${mainMod} + SHIFT + L"
                (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"right\" })")
              ];
            }
            {
              _args = [
                "${mainMod} + SHIFT + K"
                (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"up\" })")
              ];
            }
            {
              _args = [
                "${mainMod} + SHIFT + J"
                (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"down\" })")
              ];
            }

            # Resize
            {
              _args = [
                "${mainMod} + CTRL + H"
                (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = -20, y = 0 })")
              ];
            }
            {
              _args = [
                "${mainMod} + CTRL + L"
                (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 20, y = 0 })")
              ];
            }
            {
              _args = [
                "${mainMod} + CTRL + K"
                (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 0, y = -20 })")
              ];
            }
            {
              _args = [
                "${mainMod} + CTRL + J"
                (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 0, y = 20 })")
              ];
            }

            # Special workspace
            {
              _args = [
                "${mainMod} + S"
                (lib.generators.mkLuaInline "hl.dsp.workspace.toggle_special(\"magic\")")
              ];
            }
            {
              _args = [
                "${mainMod} + SHIFT + S"
                (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = \"special:magic\", follow = false })")
              ];
            }

            # Mouse drag
            {
              _args = [
                "${mainMod} + mouse:272"
                (lib.generators.mkLuaInline "hl.dsp.window.drag()")
                {mouse = true;}
              ];
            }
            {
              _args = [
                "${mainMod} + mouse:273"
                (lib.generators.mkLuaInline "hl.dsp.window.resize()")
                {mouse = true;}
              ];
            }
            # Pass through for OBS Studio
            {
              _args = [
                "ALT + F10"
                (lib.generators.mkLuaInline "hl.dsp.pass({ window = \"class:^(com\\\\.obsproject\\\\.Studio)$\" })")
              ];
            }

            # Pass through for Discord
            {
              _args = [
                "CTRL + SHIFT + M"
                (lib.generators.mkLuaInline "hl.dsp.pass({ window = \"class:^(discord)$\" })")
              ];
            }
          ]
          ++ (builtins.concatLists (
            builtins.genList (
              i: let
                key =
                  if i == 9
                  then 0
                  else i + 1;
                ws = i + 1;
              in [
                {
                  _args = [
                    "${mainMod} + ${toString key}"
                    (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = ${toString ws} })")
                  ];
                }
                {
                  _args = [
                    "${mainMod} + SHIFT + ${toString key}"
                    (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = ${toString ws}, follow = false })")
                  ];
                }
              ]
            )
            10
          ))
          ++ optionals isLaptop [
            # Pass through for OBS Studio
            {
              _args = [
                "ALT + F10"
                (lib.generators.mkLuaInline "hl.dsp.pass({ window = \"class:^(com\\\\.obsproject\\\\.Studio)$\" })")
              ];
            }

            # Pass through for Discord
            {
              _args = [
                "CTRL + SHIFT + M"
                (lib.generators.mkLuaInline "hl.dsp.pass({ window = \"class:^(discord)$\" })")
              ];
            }
            {
              _args = [
                "${mainMod} + Control_L"
                (lib.generators.mkLuaInline "hl.dsp.window.drag()")
                {mouse = true;}
              ];
            }
            {
              _args = [
                "${mainMod} + ALT_L"
                (lib.generators.mkLuaInline "hl.dsp.window.resize()")
                {mouse = true;}
              ];
            }

            # Media keys
            {
              _args = [
                "XF86AudioRaiseVolume"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+\")")
                {
                  locked = true;
                  repeating = true;
                }
              ];
            }
            {
              _args = [
                "XF86AudioLowerVolume"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-\")")
                {
                  locked = true;
                  repeating = true;
                }
              ];
            }
            {
              _args = [
                "XF86MonBrightnessUp"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl set +5%\")")
                {
                  locked = true;
                  repeating = true;
                }
              ];
            }
            {
              _args = [
                "XF86MonBrightnessDown"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl set 5%-\")")
                {
                  locked = true;
                  repeating = true;
                }
              ];
            }
            {
              _args = [
                "XF86AudioMute"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\")")
                {
                  locked = true;
                  repeating = true;
                }
              ];
            }
            {
              _args = [
                "XF86AudioPlay"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl play-pause\")")
                {locked = true;}
              ];
            }
            {
              _args = [
                "XF86AudioPrev"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl previous\")")
                {locked = true;}
              ];
            }
            {
              _args = [
                "XF86AudioNext"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl next\")")
                {locked = true;}
              ];
            }
          ];
      };
    };
  };
}
