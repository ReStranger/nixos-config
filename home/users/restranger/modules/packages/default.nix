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
      lsd.enable = true;
      mpv.enable = true;
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
        inputs.kidex.packages.${pkgs.system}.default

        ## shell ##
        bat

        ## fetch ##
        fastfetch
        cava

        ## dev tools ##
        nodejs_22
        bun
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
        nixfmt-rfc-style

        ## LSP ##

        ## Fonts ##
        corefonts
        vistafonts
        nerd-fonts.jetbrains-mono
        nerd-fonts.caskaydia-cove
        nerd-fonts.inconsolata
        nerd-fonts.fira-code
        nerd-fonts.hack

      ]
      ++ lib.optionals isWorkstation [
        onlyoffice-bin
        thunderbird-bin
        obs-studio
        spotify
        spicetify-cli
        nekoray
        krita
        transmission_4-gtk
        obsidian
        (discord.override {
          withOpenASAR = true;
          withVencord = true;
        })
      ]
      ++ lib.optionals (isLinux && isWorkstation) [
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
      ]
      ++ lib.optionals hyprlandEnable [
        inputs.quickshell.packages.${pkgs.system}.default
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
