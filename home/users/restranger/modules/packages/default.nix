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
    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePerdicate = (_: true);
    };

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
      fzf
      starship
      zoxide
      lsd
      bat
      ripgrep

      ## tui ##
      yazi
      ueberzugpp
      lazygit

      ## fetch ##
      fastfetch
      # cava

      ## dev tools ##
      lua-language-server
      stylua

      rustc
      cargo
      rust-analyzer

      clang-tools
      clang

      python312
      python312Packages.pip
      pyright
      ruff-lsp
      black
      mypy
      python312Packages.debugpy

      nodejs_22
      pnpm
      vscode-langservers-extracted
      nodePackages_latest.typescript-language-server
      prettierd
      eslint_d

      ## LSP ##
      bash-language-server
      marksman
      nixd
      hyprls
      codeium
      ## TOOLS ##
      nixpkgs-fmt

      ## Fonts ##
      corefonts
      (nerdfonts.override { fonts = [ "JetBrainsMono" "CascadiaCode" ]; })
    ] ++ lib.optionals isWorkstation [
      kitty
      firefox-devedition-bin
      anytype
      onlyoffice-bin
      thunderbird-bin
      obs-studio
      spotify
      spicetify-cli
      nekoray
      rustdesk-flutter
      krita
      inkscape
      androidStudioPackages.canary
      transmission_4-gtk
      (pkgs.writeShellScriptBin "vesktop" ''
        exec ${pkgs.vesktop}/bin/vesktop --enable-features=UseOzonePlatform,VaapiVideoDecoder,VaapiVideoEncoder --ozone-platform=x11
      '')
      (pkgs.writeShellScriptBin "obsidian" ''
        exec ${pkgs.obsidian}/bin/obsidian --enable-features=UseOzonePlatform --ozone-platform=x11
      '')
      davinci-resolve
    ] ++ lib.optionals (isLinux && isWorkstation) [
      inputs.ayugram-desktop.packages.${pkgs.system}.ayugram-desktop
      xorg.xeyes
      gnome-software
      qpwgraph
      file-roller
      figma-linux
      powertop
      wl-clipboard
      wl-clipboard-x11
      pulseaudio
    ] ++ lib.optionals hyprlandEnable [
      inputs.wezterm.packages.${pkgs.system}.default
      # alacritty-smooth-cursor
      gnome-clocks
      gnome-calculator
      wofi
      swww
      mako
      waybar
      nwg-dock-hyprland
      grimblast
      pavucontrol
      dconf-editor
      hyprshade
      brightnessctl
      playerctl
    ];
  };
}

