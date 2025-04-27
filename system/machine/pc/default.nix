_: {
  module = {
    adb.enable = true;
    boot.enable = true;
    ccache.enable = true;
    locale.enable = true;
    minimal.enable = true;
    plymouth.enable = true;
    security = {
      enable = true;
      enableBootOptions = true;
    };
    sound.enable = true;
    stylix.enable = true;
    timezone.enable = true;
    tty.enable = true;
    users.enable = true;
    virtualisation = {
      enable = true;
      docker.enable = true;
      libvirtd.enable = true;
    };

    services = {
      bluetooth.enable = true;
      flatpak.enable = true;
      greetd = {
        enable = true;
        frontend = "tui";
      };
      gvfs.enable = true;
      network = {
        enable = true;
        wifi.backend = "iwd";
      };
      openssh.enable = true;
      opentablet.enable = true;
      polkit.enable = true;
      systemd-oomd.enable = true;
      zerotier-one.enable = true;
      zram = {
        enable = true;
        deviceNumber = 2;
      };
    };

    programs = {
      dconf.enable = true;
      fonts.enable = true;
      gamemode.enable = true;
      gnupg.enable = true;
      home-manager.enable = true;
      hyprland.enable = true;
      nix-helper.enable = true;
      nix-ld.enable = true;
      tmate.enable = true;
      steam.enable = true;
      xdg-terminal-exec.enable = true;
      zsh.enable = true;
      systemPackages.enable = true;
    };
  };
}
