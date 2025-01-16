{ isWorkstation
, isLinux
, hyprlandEnable ? false
, ...
}:

{
  nixpkgs.overlays = [
    (import ../../overlays/catppuccin-qt5ct)
    (import ../../overlays/nwg-dock-hyprland)
  ];


  module = {
    firefox.enable = isWorkstation;
    zathura.enable = isWorkstation;

    dconf.enable = isLinux && isWorkstation;
    xdg-user-dirs.enable = isLinux && isWorkstation;

    nautilus.enable = hyprlandEnable && isLinux && isWorkstation;
    ags.enable = hyprlandEnable && isLinux && isWorkstation;
    hyprland.enable = hyprlandEnable && isLinux && isWorkstation;

    nix.enable = true;

    btop.enable = true;
    git.enable = true;
    nvim.enable = true;
    starship.enable = true;
    tmux.enable = true;
    yazi.enable = true;

    theme = {
      catppuccin-mocha-mauve = {
        gtk.enable = true;
        imv.enable = true;
        mpv.enable = true;
        qt.enable = true;
        # wezterm.enable = true;
        yazi.enable = true;
        zathura.enable = true;
      };
    };

    user = {
      xdg.enable = isLinux && isWorkstation;

      packages.enable = true;
    };
  };
}
