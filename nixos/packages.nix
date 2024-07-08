{ pkgs, ... }: {
  nixpkgs = { 
    config.allowUnfree = true;
    config.allowUnfreePerdicate = (_: true);
    overlays = [ 
    ];
  };

  environment.systemPackages = with pkgs; [
      home-manager
      git
      busybox
      gcc
      neovim
      tmux
      fastfetch
      pfetch
      yazi
      bat
      lsd
      ripgrep
      xclip
      wl-clipboard
      wl-clipboard-x11
      pavucontrol
      glib
      polkit_gnome
      xdg-user-dirs
      alacritty
  ];

  programs.zsh.enable = true;
  # STEAM
  programs.steam = {
      enable = true;
  };
  programs.steam.extraCompatPackages = with pkgs; [
      proton-ge-bin
  ];

  #FONTS
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    (nerdfonts.override { fonts = [ "JetBrainsMono" "CascadiaCode" ]; })
  ];

}
