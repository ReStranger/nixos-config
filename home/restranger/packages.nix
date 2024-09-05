{ inputs, pkgs, config, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    config.allowUnfreePerdicate = (_: true);
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
    
    ## tui ##
    yazi
    lazygit

    ## fetch ##
    fastfetch
    cava


    ###########################
    # desktop envirement pkgs #
    ###########################
    alacritty
    wezterm
    nautilus
    gnome-clocks
    gnome-calculator
    xdg-user-dirs
    wofi
    swww
    mako
    waybar
    nwg-dock-hyprland
    grimblast
    
    ## themes ##
    adwaita-icon-theme


    ################
    # settings app #
    ################
    nwg-look
    pavucontrol

    ##############
    # usage pkgs #
    ##############
    firefox
    obsidian
    vesktop
    
    #############
    # dev tools #
    #############
    python312
    python312Packages.pip
    nodejs_22
    pnpm


    # Re:Nvim #
    lua-language-server
    rust-analyzer
    bash-language-server
    marksman
    hyprls

    stylua
    nixpkgs-fmt

  ];
}
