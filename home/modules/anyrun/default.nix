{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.module.anyrun;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.anyrun = {
    enable = mkEnableOption "Enable anyrun program";
  };

  config = mkIf cfg.enable {
    programs.anyrun = {
      enable = true;
      config = {

        plugins = with inputs.anyrun.packages.${pkgs.stdenv.hostPlatform.system}; [
          applications
          rink
          translate
          shell
          symbols
          translate
          kidex
          dictionary
          websearch
          stdin
        ];
        closeOnClick = true;
        hidePluginInfo = true;
        hideIcons = false;
        layer = "overlay";
        maxEntries = 6;
        width = {
          fraction = 0.27;
        };
      };
      extraConfigFiles = {
        "applications.ron".text = ''
          Config(
            desktop_actions: false,
            max_entries: 6,
            terminal: Some("wezterm"),
          )
        '';

        "symbols.ron".text = ''
          Config(
            prefix: ":emo",

            symbols: {
              "shrug": "¯\\_(ツ)_/¯",
            },

            max_entries: 6,
          )
        '';

        "translate.ron".text = ''
          Config(
            prefix: ":tr",
            language_delimiter: ">",
            max_entries: 1,
          )
        '';

        "websearch.ron".text = ''
          Config(
            prefix: ":s",
            engines: [DuckDuckGo] 
          )
        '';

        "shell.ron".text = ''
          Config(
            prefix: ":sh",
            shell: zsh,
          )
        '';
        "kidex.ron".text = ''
          Config(
            max_entries: 4,
          )
        '';
        "dictionary.ron".text = ''
          Config(
            prefix: ":dic",
            max_entries: 4,
          )
        '';
      };
      extraCss =
        with config.lib.stylix.colors; # css
        ''
          * {
          font-family: ${config.stylix.fonts.serif.name};
          }

          window {
            background: transparent;
          }

          box.main {
            padding: 5px;
            margin: 10px;
            margin-top: 160px;
            border-radius: 15px;
            border: 2px solid #${base0D};
            background-color: #${base00};
            box-shadow: 1px 1px 3px 1px #1c1d1d;
          }

          text {
            min-height: 30px;
            padding: 2px 5px;
            border-radius: 5px;
          }

          .matches {
            background-color: rgba(0, 0, 0, 0);
            border-radius: 10px;
          }

          box.plugin:first-child {
            margin-top: 5px;
          }

          box.plugin.info {
            min-width: 200px;
          }

          list.plugin {
            background-color: rgba(0, 0, 0, 0);
          }

          label.match.description {
            font-size: 10px;
          }

          label.plugin.info {
            font-size: 14px;
          }

          .match {
            background: transparent;
            padding: 1px 3px;
            margin: 3px 0;
            border-radius: 9px;
          }

          .match:selected {
            background: #${base03};
            animation: fade 0.1s linear;
          }

          @keyframes fade {
            0% {
              opacity: 0;
            }

            100% {
              opacity: 1;
            }
          }
        '';
    };
  };
}
