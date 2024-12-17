{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.module.nautilus;
in
{
  options.module.nautilus = {
    enable = mkEnableOption "Enable nautilus module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nautilus
      nautilus-python
      nautilus-open-any-terminal
    ];
    home.sessionVariables = {
      NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
    };


    dconf = {
      settings."org/gnome/nautilus/icon-view" = {
        default-zoom-level = "small-plus";
      };
    };
  };
}

