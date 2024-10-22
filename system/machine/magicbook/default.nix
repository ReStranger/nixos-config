{ ...
}:
{
  module = {
    adb.enable = true;
    boot.enable = true;
    plymouth.enable = true;
    sound.enable = true;
    timezone.enable = true;
    users.enable = true;



    services = {
      greetd = {
        enable = true;
        frontend = "tui";
      };
      network.enable = true;
      polkit.enable = true;
      zapret-config.enable = true;
      zram = {
        enable = true;
        deviceNumber = 2;
      };
    };

    programs = {
      dconf.enable = true;
      gnupg.enable = true;
      home-manager.enable = true;
      hyprland.enable = true;
      kdeconnect.enable = true;
      nix-helper.enable = true;
      zsh.enable = true;
      systemPackages.enable = true;
    };
  };
}
