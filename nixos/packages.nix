{ pkgs, ... }: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePerdicate = (_: true);
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
        mur = import (builtins.fetchTarball "https://github.com/duvetfall/mur/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
    };
    overlays = [
      (self: super: {
        alacritty-smooth-cursor = super.alacritty.override (old: {
          rustPlatform = old.rustPlatform // {
            buildRustPackage = args: old.rustPlatform.buildRustPackage (args // {
              src = pkgs.fetchFromGitHub {
                owner = "GregTheMadMonk";
                repo = "alacritty-smooth-cursor";
                rev = "303a92ea57a074bb50ff016c8da7a0aeae897b1a";
                hash = "sha256-aoel3P7MnO39ekBJPaTnaizJkbUaOS7sy1ktwow9JN8=";
              };

              cargoHash = "sha256-2kLlB6YXZZYX+HtKcdjr9z9hh8AW54Dkc1bLWjueKVQ=";
            });
          };
        });
      })
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
    # alacritty
    alacritty-smooth-cursor
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
