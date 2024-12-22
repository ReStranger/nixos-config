{ config
, pkgs
, lib
, inputs
, ...
}:

with lib;

let
  cfg = config.module.ags;
in
{
  options.module.ags = {
    enable = mkEnableOption "Enable ags module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bun
      dart-sass
      # sassc
      # fd
      brightnessctl
      swww
      # slurp
      hyprpicker
      pavucontrol
      networkmanager
      gtk3
      adw-gtk3
      morewaita-icon-theme
      inputs.matugen.packages.${pkg.system}.default
      material-symbols
    ];

    programs.ags = {
      enable = true;

      # null or path, leave as null if you don't want hm to manage the config
      # configDir = /home/${username}/.config/my-ags;

      # additional packages to add to gjs's runtime
      extraPackages = with pkgs; [
        fzf
        wrapGAppsHook
        gobject-introspection
      ] ++ (with inputs.astal.packages.${pkg.system}; [
        io
        astal3
        apps
        battery
        hyprland
        mpris
        network
        notifd
        powerprofiles
        tray
        wireplumber
      ]);
    };
  };
}
