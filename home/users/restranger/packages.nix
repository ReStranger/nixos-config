{ inputs, pkgs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    config.allowUnfreePerdicate = (_: true);
    overlays = [
      (import ./overlays/alacritty-overlay.nix)
      (import ../../overlays/freesmlauncher-unwrapped)
    ];
  };
  programs = {
    imv.enable = true;
    mpv.enable = true;
  };

  home.packages = with pkgs; [
    #############
    # cli tools #
    #############

    ## system control ##
    brightnessctl
    playerctl
    btop
    powertop
    wl-clipboard
    wl-clipboard-x11
    hyprshade
    pulseaudio

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
    cava


    ###########################
    # desktop envirement pkgs #
    ###########################
    kitty
    # alacritty
    # alacritty-smooth-cursor
    gnome-clocks
    gnome-calculator
    wofi
    swww
    mako
    waybar
    nwg-dock-hyprland
    grimblast

    ################
    # settings app #
    ################
    pavucontrol
    dconf-editor

    ##############
    # usage pkgs #
    ##############
    firefox
    inputs.ayugram-desktop.packages.${pkgs.system}.ayugram-desktop
    onlyoffice-bin
    thunderbird-bin
    xorg.xeyes
    spotify
    spicetify-cli
    nekoray
    rustdesk-flutter
    gnome-software
    krita
    inkscape
    # androidStudioPackages.canary
    transmission_4-gtk
    qpwgraph
    file-roller
    figma-linux
    anytype
    obs-studio
    (pkgs.writeShellScriptBin "vesktop" ''
    exec ${pkgs.vesktop}/bin/vesktop --enable-features=UseOzonePlatform,VaapiVideoDecoder,VaapiVideoEncoder --ozone-platform=x11
    '')
    (pkgs.writeShellScriptBin "obsidian" ''
    exec ${pkgs.obsidian}/bin/obsidian --enable-features=UseOzonePlatform --ozone-platform=x11
    '')
    # freesmlauncher


    #############
    # dev tools #
    #############
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

    unzip
    ### LSP ###
    bash-language-server
    marksman
    nixd
    hyprls
    codeium
    ### TOOLS ###
    nixpkgs-fmt
  ];
}
