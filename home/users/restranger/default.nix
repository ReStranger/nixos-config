{
  isWorkstation,
  isLinux,
  hyprlandEnable ? false,
  ...
}:

{
  # nixpkgs.overlays = [
  #   (import ../../overlays/catppuccin-qt5ct)
  # ];

  stylix.targets = {
    firefox.profileNames = [ "default" ];
    neovim.enable = false;
  };
  module = {
    firefox.enable = isWorkstation;
    zathura.enable = isWorkstation;
    stylix.enable = isWorkstation;
    zsh.enable = isWorkstation;

    dconf.enable = isLinux && isWorkstation;
    xdg-user-dirs.enable = isLinux && isWorkstation;
    gtk.enable = isLinux && isWorkstation;
    wezterm.enable = isLinux && isWorkstation;

    ags.enable = hyprlandEnable && isLinux && isWorkstation;
    anyrun.enable = hyprlandEnable && isLinux && isWorkstation;
    nautilus.enable = hyprlandEnable && isLinux && isWorkstation;
    hyprland.enable = hyprlandEnable && isLinux && isWorkstation;

    nix.enable = true;

    btop.enable = true;
    git.enable = true;
    lazygit.enable = true;
    nvim.enable = true;
    sops.enable = true;
    starship.enable = true;
    tmux.enable = true;
    yazi.enable = true;

    user = {
      xdg.enable = isLinux && isWorkstation;

      packages.enable = true;
    };
  };
}
