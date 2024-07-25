{ inputs, pkgs, config, ... }:
{
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
    lazygit
    btop
    vscode
    hyprpicker
    spotify
    spicetify-cli
    bun
    fd
    gjs
    typescript
    sassc
    dart-sass
    brightnessctl
    lua-language-server
    stylua
    rust-analyzer
    clang
    clang-tools
    marksman
    unrar
    alacritty
    onlyoffice-bin_latest
  ];

  imports = [ inputs.ags.homeManagerModules.default ];
  programs.ags = {
    enable = true;

    # null or path, leave as null if you don't want hm to manage the config
    #    configDir = ../ags;

    # additional packages to add to gjs's runtime
    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };

}
