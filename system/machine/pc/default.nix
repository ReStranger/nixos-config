{pkgs, ...}: {
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
      llama-cpp = {
        enable = true;
        package = pkgs.llama-cpp-vulkan;
        contextSize = 65536;
        threads = 8;
        gpuLayers = 99;
        extraSettings = {
          reasoning-preserve = true;
          # n-cpu-moe = 24;
          # cmoeThreads = 12;

          models-dir = "/mnt/sda1/llama/models/";
          models-max = 1;
          sleep-idle-seconds = -1;
          temp = 0.6;
          top-p = 0.95;
          top-k = 20;
          repeat-penalty = 1.05;
          n-predict = 16384;
        };
      };
      openssh.enable = true;
      opentablet.enable = true;
      polkit.enable = true;
      scx.enable = true;
      systemd-oomd.enable = true;
      tailscale.enable = true;
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
