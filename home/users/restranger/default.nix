{ isWorkstation
, isLinux
, hyprlandEnable ? false
, ...
}:

{
  nixpkgs.overlays = [  ];


  module = {
    wezterm.enable   = isWorkstation;
    zathura.enable   = isWorkstation;

    dconf.enable               = isLinux && isWorkstation;
    xdg-user-dirs.enable       = isLinux && isWorkstation;

    nemo.enable       = hyprlandEnable && isLinux && isWorkstation;
    ags.enable        = hyprlandEnable && isLinux && isWorkstation;
    hyprland.enable   = hyprlandEnable && isLinux && isWorkstation;

    git.enable           = true;
    nvim.enable          = true;
    starship.enable      = true;
    tmux.enable          = true;
    yazi.enable          = true;
    
    theme = {
      cattpucin-mocha-mauve = {
        gtk.enable = true;
        imv.enable = true;
        mpv.enable = true;
        # wezterm.enable = true;
        yazi.enable = true;
        zathura.enable = true;
      };
    };

    user = {
      xdg.enable          = isLinux && isWorkstation;

      packages.enable = true;
    };
  };
}
