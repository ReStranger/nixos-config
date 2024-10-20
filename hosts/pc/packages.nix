{ pkgs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    config.allowUnfreePerdicate = (_: true);
  };
  environment.systemPackages = with pkgs; [
    neovim
    tmux
    wget
    home-manager
    git
    busybox
    (pkgs.writeShellScriptBin "vesktop" ''
    exec ${pkgs.vesktop}/bin/vesktop --enable-features=UseOzonePlatform,VaapiVideoDecoder,VaapiVideoEncoder --ozone-platform=x11
    '')
    (pkgs.writeShellScriptBin "obsidian" ''
    exec ${pkgs.obsidian}/bin/obsidian --enable-features=UseOzonePlatform --ozone-platform=x11
    '')
    nvidia-vaapi-driver
    cudaPackages.cudatoolkit
  ];
  programs = {
      nix-ld = {
        enable = true;
        libraries = [];
    };
    zsh.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    (nerdfonts.override { fonts = [ "JetBrainsMono" "CascadiaCode" ]; })
  ];
  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [ "kitty.desktop" ];
    };
  };
  nix = {
    settings = {
      substituters = [
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
  };
}
