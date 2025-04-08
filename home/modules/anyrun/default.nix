{ config
, lib
, pkgs
, inputs
, ...
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

        plugins = with inputs.anyrun.packages.${pkgs.system}; [
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
      };
       extraConfigFiles = {
          "applications.ron".text = ''
            Config(
              desktop_actions: false,
              max_entries: 10,
              terminal: Some("wezterm"),
            )
          '';

          "symbols.ron".text = ''
            Config(
              prefix: ":emo",

              symbols: {
                // "name": "text to be copied"
                "shrug": "¯\\_(ツ)_/¯",
              },

              max_entries: 10,
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
              max_entries: 6,
            )
          '';
          "dictionary.ron".text = ''
            Config(
              prefix: ":def",
              max_entries: 6,
            )
          '';
        };
    };
  };
}
