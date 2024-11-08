{ config
, pkgs
, lib
, ...
}:

with lib;

let
  cfg = config.module.ags;
in {
  options.module.ags = {
    enable = mkEnableOption "Enable ags module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bun
      dart-sass
      sassc
      fd
      brightnessctl
      swww
      slurp
      hyprpicker
      pavucontrol
      networkmanager
      gtk3
      adw-gtk3
      morewaita-icon-theme
    ];

    programs.ags = {
      enable = true;

      # null or path, leave as null if you don't want hm to manage the config
      configDir = ../ags;

      # additional packages to add to gjs's runtime
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk_6_0
        accountsservice
      ];
    };
  };
}
