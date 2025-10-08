{
  config,
  lib,
  pkgs,
  inputs,
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
      imv.enable = true;
      jq.enable = true;
      lazydocker.enable = true;
      lsd.enable = true;
      mpv.enable = true;
      ripgrep.enable = true;
      zen-browser.enable = true;
      zoxide.enable = true;
    };

    home.packages =
      with pkgs;
      [
        ## system tools ##
        unzip
        unrar
        p7zip

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
        vistafonts
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
        onlyoffice-bin
        obs-studio
        nekoray
        krita
        amberol
        transmission_4-gtk
        obsidian
        (discord.override {
          withOpenASAR = true;
          withVencord = true;
        })
        (prismlauncher.override {
          additionalPrograms = [
            glfw3-minecraft
            ffmpeg
          ];
        })
      ]
      ++ lib.optionals (isLinux && isWorkstation) [
        ayugram-desktop
        file-roller
        pulseaudio
        libnotify
      ]
      ++ lib.optionals hyprlandEnable [
        gnome-clocks
        gnome-calculator
        wl-clipboard-rs
        wl-clipboard-x11
        brightnessctl
        playerctl
        pavucontrol
        swww
        grimblast
        hyprpicker
      ];
  };
}
