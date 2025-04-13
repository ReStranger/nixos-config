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
        closeOnClick = true;
        hidePluginInfo = true;
        hideIcons = false;
        layer = "overlay";
        maxEntries = 6;
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
               // "name": "text to be copied"
               "shrug": "¯\\_(ツ)_/¯",
             },

             max_entries: 4,
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
             prefix: ":def",
             max_entries: 4,
           )
         '';
        };
        extraCss = with config.lib.stylix.colors; /* css */''
* {
  font-family: ${config.stylix.fonts.serif.name};
  font-size: 1.1rem;
  font-weight: 600;
}

#window,
#match,
#plugin,
#main {
  background: transparent;
}

#match:selected {
  background: #${base03};}

#match {
  padding: 3px;
  margin: 2px 0;
  border-radius: 9px;
}

#entry,
#plugin:hover {
  border-radius: 9px;
}

box#main {
  padding: 10px;
  margin-top: 160px;
  box-shadow: 1px 1px 3px 1px #1c1d1d;
  background: #${base00};
  border-radius: 14px;
}
        '';
    };
  };
}
