{
  config,
  lib,
  pkgs,
  hostname,
  hyprlandEnable,
  ...
}:

let
  cfg = config.module.nwg-dock;
  inherit (lib) mkEnableOption mkIf;
  nwg-dock-name = if hyprlandEnable then "nwg-dock-hyprland" else "nwg-dock";
  nwg-dock-options = if hostname == "pc" then "-nolauncher -mb 5 -x" else "-nolauncher -mb 10 -d";
in
{
  options.module.nwg-dock = {
    enable = mkEnableOption "Enable nwg-dock module";
  };

  config = mkIf cfg.enable {
    home.packages =
      if hyprlandEnable then
        [
          pkgs.nwg-dock-hyprland
        ]
      else
        [
          pkgs.nwg-dock
        ];
    home.file.".config/${if hyprlandEnable then "nwg-dock-hyprland" else "nwg-dock"}/style.css".text =
      with config.lib.stylix.colors; # css
      ''
        window {
          background-color: transparent;
        }

        #box {
          background: #${base00};
          border-style: none;
          border-width: 1px;
          box-shadow:
            0 0 0 1px rgba(238, 238, 238, 0.04) inset,
            2px 3px 8px 0 alpha(black, 0.4);
          padding: 5px;
          padding-top: 8px;
          border-radius: 15px;
          margin: 8px;
          margin-top: 0px;
        }

        #active {
        }

        button,
        image {
          background: none;
          border-style: none;
          box-shadow: none;
          color: #${base04};
        }

        button {
          padding: 4px;
          margin-left: 4px;
          margin-right: 4px;
          color: #${base05};
          font-size: 12px;
        }

        button:hover {
          background-color: rgba(238, 238, 238, 0.06);
          box-shadow: 0 0 0 1px rgba(238, 238, 238, 0.04) inset;
          border-radius: 15px;
        }

        button:focus {
          box-shadow: none;
        }
      '';
    xdg.configFile = {
      "${nwg-dock-name}/nwg-dock".text = # bash
        ''
          #!/usr/bin/env bash

          while true; do
              ${nwg-dock-name} ${nwg-dock-options}
          done
        '';
    };
  };
}
