_: {
  module = {
    adb.enable = true;
    boot.enable = true;
    ccache.enable = true;
    locale.enable = true;
    plymouth.enable = true;
    security = {
      enable = true;
      enableBootOptions = true;
    };
    sops.enable = true;
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
      greetd = {
        enable = true;
        frontend = "tui";
      };
      gvfs.enable = true;
      irqbalance.enable = true;
      network = {
        enable = true;
        wifi.backend = "iwd";
      };
      openssh.enable = true;
      opentablet.enable = true;
      polkit.enable = true;
      scx.enable = true;
      systemd-oomd.enable = true;
      zerotier-one = {
        enable = true;
        joinNetworks = [
          "8bd5124fd65dec01" # re_sshd
          "af415e486f516107" # party
        ];
      };
      zram = {
        enable = true;
        deviceNumber = 2;
      };
    };

    programs = {
      corectrl.enable = true;
      fonts.enable = true;
      gamemode.enable = true;
      gnupg.enable = true;
      home-manager.enable = true;
      hyprland.enable = true;
      throne.enable = true;
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
