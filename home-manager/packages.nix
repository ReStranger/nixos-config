{ pkgs, ... }: {
  nixpkgs = { 
    config.allowUnfree = true;
    config.allowUnfreePerdicate = (_: true);
  };
  home.packages = with pkgs; [
    telegram-desktop
    nwg-look
    gnome-calculator
    gnome.gnome-clocks
    nekoray
    alacritty
    wofi
    vesktop
    obsidian
    firefox-bin
    xorg.xeyes
    waybar
    starship
    fzf
    zoxide
    cinnamon.nemo
    cinnamon.nemo-fileroller
    grimblast
    swww
    mako
    lua-language-server
    lazygit
    btop
    clang
    clang-tools
    marksman
    rust-analyzer
    vscode
    hyprpicker
  ];
}
