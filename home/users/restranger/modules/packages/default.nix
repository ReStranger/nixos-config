{ config
, lib
, pkgs
, inputs
, isWorkstation
, hyprlandEnable
, ...
}:

with lib;

let
  inherit (pkgs.stdenv) isLinux;
  cfg = config.module.user.packages;
in
{
  options.module.user.packages = {
    enable = mkEnableOption "Enable user packages";
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    programs = {
      imv.enable = true;
      mpv.enable = true;
    };

    home.packages = with pkgs; [
      ## system tools ##
      unzip
      unrar
      p7zip

      ## shell ##
      starship
      bat

      ## tui ##
      yazi

      ## fetch ##
      fastfetch
      # cava

      ## dev tools ##
      nodejs_22
      pnpm
      vscode-js-debug
      python312
      python312Packages.pip
      uv
      clang-tools
      llvmPackages_latest.clang
      llvmPackages_latest.lldb
      gnumake
      cmake
      cargo
      rustc
      nixpkgs-fmt

      ## LSP ##

      ## Fonts ##
      corefonts
      vistafonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.caskaydia-cove
      nerd-fonts.inconsolata
      nerd-fonts.fira-code
      nerd-fonts.hack

    ] ++ lib.optionals isWorkstation [
      onlyoffice-bin
      thunderbird-bin
      obs-studio
      spotify
      spicetify-cli
      nekoray
      krita
      transmission_4-gtk
      obsidian
      discord
    ] ++ lib.optionals (isLinux && isWorkstation) [
      inputs.ayugram-desktop.packages.${pkgs.system}.ayugram-desktop
      xorg.xeyes
      gnome-software
      qpwgraph
      file-roller
      figma-linux
      wl-clipboard
      wl-clipboard-x11
      pulseaudio
      libnotify
    ] ++ lib.optionals hyprlandEnable [
      inputs.wezterm.packages.${pkgs.system}.default
      gnome-clocks
      gnome-calculator
      overskride
      wofi
      swww
      mako
      waybar
      nwg-dock-hyprland
      grimblast
      pavucontrol
      dconf-editor
      hyprpicker
      brightnessctl
      playerctl
    ];
  };
}

