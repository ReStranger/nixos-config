{ ...
}:
{
  module = {
    adb.enable = true;
    boot.enable = true;
    locale.enable = true;
    minimal.enable = true;
    plymouth.enable = true;
    sound.enable = true;
    timezone.enable = true;
    tty.enable = true;
    users.enable = true;

    services = {
      flatpak.enable = true;
      greetd = {
        enable = true;
        frontend = "tui";
      };
      gvfs.enable = true;
      network.enable = true;
      openssh.enable = true;
      polkit.enable = true;
      systemd-oomd.enable = true;
      zapret-config.enable = true;
      zerotier-one.enable = true;
      zram = {
        enable = true;
        deviceNumber = 2;
      };
    };

    programs = {
      dconf.enable = true;
      fonts.enable = true;
      gnupg.enable = true;
      home-manager.enable = true;
      hyprland.enable = true;
      kdeconnect.enable = true;
      nix-helper.enable = true;
      nix-ld.enable = true;
      steam.enable = true;
      zsh.enable = true;
      systemPackages.enable = true;
    };
  };
}
