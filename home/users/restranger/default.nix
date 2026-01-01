{
  isWorkstation,
  isLinux,
  hyprlandEnable ? false,
  ...
}:

{
  stylix.targets = {
    neovim.enable = false;
    zen-browser.enable = false;
  };
  module = {
    zathura.enable = isWorkstation;
    stylix.enable = isWorkstation;
    zsh.enable = isWorkstation;
    zen-browser.enable = isWorkstation;

    dconf.enable = isLinux && isWorkstation;
    xdg-user-dirs.enable = isLinux && isWorkstation;
    gtk.enable = isLinux && isWorkstation;
    mangohud.enable = isLinux && isWorkstation;
    wezterm.enable = isLinux && isWorkstation;

    anyrun.enable = hyprlandEnable && isLinux && isWorkstation;
    discord.enable = hyprlandEnable && isLinux && isWorkstation;
    kidex.enable = hyprlandEnable && isLinux && isWorkstation;
    nautilus.enable = hyprlandEnable && isLinux && isWorkstation;
    hyprland.enable = hyprlandEnable && isLinux && isWorkstation;
    quickshell.enable = hyprlandEnable && isLinux && isWorkstation;

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
