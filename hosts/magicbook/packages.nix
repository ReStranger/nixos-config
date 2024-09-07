{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim
    tmux
    wget
    coreutils
    home-manager
    git
    gcc
    clang
    clang-tools
    rustc
    cargo
    busybox
  ];
  programs.zsh.enable = true;
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
}
