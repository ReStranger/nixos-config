{ inputs, pkgs, config, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    config.allowUnfreePerdicate = (_: true);
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
    spoofdpi

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
    lazygit

    ## fetch ##
    fastfetch
    cava


    ###########################
    # desktop envirement pkgs #
    ###########################
    kitty
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
    pika-backup
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

    #############
    # dev tools #
    #############
    python312
    python312Packages.pip
    nodejs_22
    pnpm
  ];
}
