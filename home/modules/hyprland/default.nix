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
    mkForce
    optionals
    getExe
    getExe'
    optional
    ;
  inherit (lib.types) enum;
  inherit (lib.hm.dag) entryAfter;
  inherit (lib.generators) mkLuaInline;

  terminal = "${getExe inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default}";
  fileManager = "${getExe pkgs.kdePackages.dolphin}";
  menu = "${getExe inputs.anyrun.packages.${pkgs.stdenv.hostPlatform.system}.anyrun}";

  sessionVariables = import ./variables;
  windowRules = import ./window-rules;
in {
  imports = ["${self}/home/modules/hyprland/styles"];

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
    home.sessionVariables = sessionVariables;
    home = {
      activation.rebuildKdeCache = entryAfter ["writeBoundary"] ''
        ${pkgs.kdePackages.kservice}/bin/kbuildsycoca6 --noincremental
      '';
      inherit sessionVariables;
    };
    module.hyprland = {
      styles.round.enable = cfg.style == "round";
      styles.flat.enable = cfg.style == "flat";
    };
    dconf.settings."org/gnome/desktop/wm/preferences" = {
      button-layout = "";
    };
    systemd.user.services.polkit-kde-authentication-agent-1 = {
      Unit = {
        Description = "polkit-kde-authentication-agent-1";
        Wants = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };
      Install = {
        WantedBy = ["graphical-session.target"];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      xwayland.enable = true;
      systemd.enable = false;
      configType = "lua";
      plugins = [
        # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.csgo-vulkan-fix
      ];
      settings =
        {
          monitor = [
            {
              output = "";
              mode = "preferred";
              position = "auto";
              scale = "auto";
            }
          ];

          # on = {
          #   _args = let
          #     f = path:
          #       mkLuaInline ''
          #         function()
          #           hl.exec_cmd("uwsm app -- ${path}")
          #         end
          #       '';
          #   in [
          #     "hyprland.start"
          #     (f "${pkgs.awww}/bin/awww")
          #   ];
          # };
          config = {
            general = {
              resize_on_border = false;
              allow_tearing = true;
              layout = "dwindle";
            };

            decoration = {
              shadow = {
                color = mkForce "rgba(12121499)";
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

            xwayland = {
              enabled = true;
              force_zero_scaling = true;
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

            # plugin = {
            #   csgo_vulkan_fix = {
            #     fix_mouse = true;
            #   };
            # };

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
              workspace_name = "magic";
            }
            {
              fingers = 2;
              direction = "pinch";
              action = "cursorZoom";
              zoom_level = 1;
              mode = "live";
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
          # "plugin.csgo_vulkan_fix.vkfix_app" = let
          #   app = name: w: h: {
          #     app = name;
          #     inherit w h;
          #   };
          # in [
          #   (app "cs2" 1440 1080)
          # ];

          bind = let
            mainMod = "SUPER";

            f = key: path: opts: {
              _args =
                [
                  key
                  (mkLuaInline ''hl.dsp.exec_cmd("uwsm app -- ${path}")'')
                ]
                ++ optional (opts != {}) opts;
            };

            d = key: code: opts: {
              _args =
                [
                  key
                  (mkLuaInline code)
                ]
                ++ optional (opts != {}) opts;
            };
          in
            [
              # Launchers
              (f "${mainMod} + T" "${terminal}" {})
              (d "${mainMod} + Q" "hl.dsp.window.close()" {})
              (d "${mainMod} + SHIFT + Q" "hl.dsp.window.kill()" {})
              (f "${mainMod} + E" "${fileManager}" {})
              (f "${mainMod} + D" "${menu}" {})
              (f "${mainMod} + C" "${getExe pkgs.hyprpicker} --autocopy" {})
              (f "${mainMod} + ALT + R" "hyprctl reload" {})

              # Window state
              (d "${mainMod} + ALT + R" "hl.dsp.layout(\"togglesplit\")" {})
              (d "${mainMod} + SHIFT + F" "hl.dsp.window.float({ action = \"toggle\" })" {})
              (d "${mainMod} + F" "hl.dsp.window.fullscreen()" {})
              (d "${mainMod} + SHIFT + P" "hl.dsp.window.pseudo()" {})

              # Clipboard / screenshots
              (f "CTRL + Print" "${getExe pkgs.grimblast} --notify --freeze copy area" {})
              (f "CTRL + SHIFT + Print" "${getExe pkgs.grimblast} --notify --freeze copysave area $HOME/Pictures/Screenshots/$(date '+%Y-%m-%d--%H-%M-%S')-screenshot.png" {})
              (d "${mainMod} + L" "hl.dsp.focus({ direction = \"right\" })" {})
              (d "${mainMod} + H" "hl.dsp.focus({ direction = \"left\" })" {})
              (d "${mainMod} + K" "hl.dsp.focus({ direction = \"up\" })" {})
              (d "${mainMod} + J" "hl.dsp.focus({ direction = \"down\" })" {})

              # Window swap
              (d "${mainMod} + SHIFT + H" "hl.dsp.window.move({ direction = \"left\" })" {})
              (d "${mainMod} + SHIFT + L" "hl.dsp.window.move({ direction = \"right\" })" {})
              (d "${mainMod} + SHIFT + K" "hl.dsp.window.move({ direction = \"up\" })" {})
              (d "${mainMod} + SHIFT + J" "hl.dsp.window.move({ direction = \"down\" })" {})

              # Resize
              (d "${mainMod} + CTRL + H" "hl.dsp.window.resize({ x = -20, y = 0, relative = true })" {})
              (d "${mainMod} + CTRL + L" "hl.dsp.window.resize({ x = 20, y = 0, relative = true })" {})
              (d "${mainMod} + CTRL + K" "hl.dsp.window.resize({ x = 0, y = -20, relative = true })" {})
              (d "${mainMod} + CTRL + J" "hl.dsp.window.resize({ x = 0, y = 20, relative = true })" {})

              # Special workspace
              (d "${mainMod} + S" "hl.dsp.workspace.toggle_special(\"magic\")" {})
              (d "${mainMod} + SHIFT + S" "hl.dsp.window.move({ workspace = \"special:magic\", follow = false })" {})

              # Mouse drag
              (d "${mainMod} + mouse:272" "hl.dsp.window.drag()" {mouse = true;})
              (d "${mainMod} + mouse:273" "hl.dsp.window.resize()" {mouse = true;})

              # Pass through for OBS Studio
              (d "ALT + F10" "hl.dsp.pass({ window = \"class:^(com\\\\.obsproject\\\\.Studio)$\" })" {})

              # Pass through for Discord
              (d "CTRL + SHIFT + M" "hl.dsp.pass({ window = \"class:^(discord)$\" })" {})
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
                  (d "${mainMod} + ${toString key}" "hl.dsp.focus({ workspace = ${toString ws} })" {})
                  (d "${mainMod} + SHIFT + ${toString key}" "hl.dsp.window.move({ workspace = ${toString ws}, follow = false })" {})
                ]
              )
              10
            ))
            ++ optionals isLaptop [
              # Pass through for OBS Studio
              (d "ALT + F10" "hl.dsp.pass({ window = \"class:^(com\\\\.obsproject\\\\.Studio)$\" })" {})

              # Pass through for Discord
              (d "CTRL + SHIFT + M" "hl.dsp.pass({ window = \"class:^(discord)$\" })" {})
              (d "${mainMod} + Control_L" "hl.dsp.window.drag()" {mouse = true;})
              (d "${mainMod} + ALT_L" "hl.dsp.window.resize()" {mouse = true;})

              # Media keys
              (f "XF86AudioRaiseVolume" "${getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 5%+" {
                locked = true;
                repeating = true;
              })
              (f "XF86AudioLowerVolume" "${getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 5%-" {
                locked = true;
                repeating = true;
              })
              (f "XF86MonBrightnessUp" "${getExe pkgs.brightnessctl} set +5%" {
                locked = true;
                repeating = true;
              })
              (f "XF86MonBrightnessDown" "${getExe pkgs.brightnessctl} set 5%-" {
                locked = true;
                repeating = true;
              })
              (f "XF86AudioMute" "${getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle" {
                locked = true;
                repeating = true;
              })
              (f "XF86AudioPlay" "${getExe pkgs.playerctl} play-pause" {locked = true;})
              (f "XF86AudioPrev" "${getExe pkgs.playerctl} previous" {locked = true;})
              (f "XF86AudioNext" "${getExe pkgs.playerctl} next" {locked = true;})
            ];
        }
        // windowRules;
    };
  };
}
