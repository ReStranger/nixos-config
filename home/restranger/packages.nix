{ inputs, pkgs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    config.allowUnfreePerdicate = (_: true);
    overlays = [
      (import ./overlays/alacritty-overlay.nix)
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
    inputs.ayugram-desktop.packages.${pkgs.system}.default
    onlyoffice-bin
    thunderbird-bin
    xorg.xeyes
    spotify
    spicetify-cli
    syncthing
    nekoray
    rustdesk-flutter
    gnome-software
    krita
    inkscape
    androidStudioPackages.canary
    transmission_4-gtk
    qpwgraph
    file-roller
    figma-linux
    anytype

    #############
    # dev tools #
    #############
    python312
    python312Packages.pip
    nodejs_22
    pnpm
  ];
}
