{ isWorkstation
, isLinux
, hyprlandEnable ? false
, ...
}:

{
  nixpkgs.overlays = [  ];


  module = {
    alacritty.enable = isWorkstation;
    zathura.enable   = isWorkstation;

    dconf.enable               = isLinux && isWorkstation;
    xdg-user-dirs.enable       = isLinux && isWorkstation;

    nemo.enable       = hyprlandEnable && isLinux && isWorkstation;
    ags.enable = hyprlandEnable && isLinux && isWorkstation;
    hyprland.enable   = hyprlandEnable && isLinux && isWorkstation;

    git.enable           = true;
    nvim.enable          = true;
    starship.enable      = true;
    tmux.enable          = true;
    yazi.enable          = true;
    
    theme = {
      cattpucin-mocha-mauve = {
        alacritty.enable = true;
        gtk.enable = true;
        imv.enable = true;
        mpv.enable = true;
        yazi.enable = true;
        zathura.enable = true;
      };
    };

    user = {
      # xdg.enable          = isLinux && isWorkstation;

      packages.enable = true;
    };
  };
}
