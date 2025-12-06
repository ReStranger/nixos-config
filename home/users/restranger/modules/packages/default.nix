{
  config,
  lib,
  pkgs,
  isWorkstation,
  hyprlandEnable,
  ...
}:

let
  cfg = config.module.user.packages;
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) mkEnableOption mkIf;

in
{
  options.module.user.packages = {
    enable = mkEnableOption "Enable user packages";
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    programs = {
      cava.enable = true;
      fd.enable = true;
      fzf.enable = true;
      jq.enable = true;
      lazydocker.enable = true;
      lsd.enable = true;
      mangohud.enable = true;
      ripgrep.enable = true;
      zoxide.enable = true;
    };

    home.packages =
      with pkgs;
      [
        ## system tools ##
        unzip
        unrar
        p7zip
        curl
        wget
        lm_sensors
        systemctl-tui

        ## shell ##
        bat

        ## fetch ##
        fastfetch

        ## dev tools ##
        nodejs_22
        pnpm
        vscode-js-debug
        clang-tools
        llvmPackages_latest.clang
        llvmPackages_latest.lldb
        gnumake
        cmake
        nixfmt-rfc-style

        ## LSP ##

        ## Fonts ##
        corefonts
        vista-fonts
        rubik
        cantarell-fonts
        material-symbols
        nerd-fonts.jetbrains-mono
        nerd-fonts.caskaydia-cove
        nerd-fonts.inconsolata
        nerd-fonts.fira-code
        nerd-fonts.hack
        nerd-fonts.ubuntu

      ]
      ++ lib.optionals isWorkstation [
        onlyoffice-desktopeditors
        obs-studio
        eog
        vlc
        krita
        amberol
        hieroglyphic
        transmission_4-gtk
        obsidian
        (prismlauncher.override {
          additionalPrograms = [
            glfw3-minecraft
            ffmpeg
          ];
        })
        lunar-client
      ]
      ++ lib.optionals (isLinux && isWorkstation) [
        (callPackage ../../../../overlays/davinci-resolve-studio.nix { })
        ayugram-desktop
        libnotify
      ]
      ++ lib.optionals hyprlandEnable [
        file-roller
        gnome-clocks
        gnome-calculator
        gnome-software
        wl-clipboard
        wl-clipboard-x11
        overskride
        brightnessctl
        playerctl
        pwvucontrol
        swww
        grimblast
        hyprpicker
      ];
  };
}
