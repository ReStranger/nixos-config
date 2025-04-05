{ config
, pkgs
, lib
, inputs
, ...
}:


let
  cfg = config.module.ags;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.ags = {
    enable = mkEnableOption "Enable ags module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dart-sass
      brightnessctl
      swww
      hyprpicker
      networkmanager
      adw-gtk3
      morewaita-icon-theme
    ];

    programs.ags = {
      enable = true;

      # null or path, leave as null if you don't want hm to manage the config
      # configDir = /home/${username}/.config/my-ags;

      # additional packages to add to gjs's runtime
      extraPackages = with pkgs; [
        fzf
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
