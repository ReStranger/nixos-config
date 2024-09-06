{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim
    tmux
    wget
    home-manager
    git
    gcc
    clang
    clang-tools
    rustc
    cargo
  ];
  programs.zsh.enable = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    (nerdfonts.override { fonts = [ "JetBrainsMono" "CascadiaCode" ]; })
  ];
  environment.variables.XDG_CONFIG_DIRS = [ "/etc/xdg" ]; # we should probably have this in NixOS by default
  environment.etc."xdg/mimeapps.list" = {
    text = ''
      [Default Applications]
      mime/type=alacritty.desktop;
    '';
  };
}
