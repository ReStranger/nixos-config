{ username, ... }:
{
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
    users = {
      enable = true;
      ${username}.hashedPassword =
        "$6$/k2DxKT/Biwenuzi$rxMb4alvs9KiBsfrI4UIiTWpTNYgvpvq8jGLl1thkTKX00APg6EPt1E9mO6DgpDHrOjwFWlmLwQiLcIk.w4o20";
      root.hashedPassword = "$6$/k2DxKT/Biwenuzi$rxMb4alvs9KiBsfrI4UIiTWpTNYgvpvq8jGLl1thkTKX00APg6EPt1E9mO6DgpDHrOjwFWlmLwQiLcIk.w4o20";
    };
    virtualisation = {
      enable = true;
      docker.enable = true;
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
        wifi = {
          backend = "iwd";
          macAddress = "random";
        };
      };
      openssh.enable = true;
      opentablet.enable = true;
      polkit.enable = true;
      power-profiles-daemon.enable = true;
      scx.enable = true;
      systemd-oomd.enable = true;
      upower.enable = true;
      zerotier-one.enable = true;
      zram = {
        enable = true;
        deviceNumber = 2;
      };
    };

    programs = {
      corectrl.enable = true;
      fonts.enable = true;
      gnupg.enable = true;
      gamemode.enable = true;
      home-manager.enable = true;
      hyprland.enable = true;
      nekoray.enable = true;
      nix-helper.enable = true;
      nix-ld.enable = true;
      steam.enable = true;
      xdg-terminal-exec.enable = true;
      zsh.enable = true;
      systemPackages.enable = true;
    };
  };
}
