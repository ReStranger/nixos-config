{ pkgs
, lib
, config
, ...
}:

with lib;

let
  cfg = config.module.programs.systemPackages;
in
{
  options.module.programs.systemPackages.enable = mkEnableOption "Enable System Software";

  config = mkIf cfg.enable {
    programs.nano.enable = false;
    environment.systemPackages = with pkgs; [
      # Utils
      neovim
      tmux
      wget
      home-manager
      git
      busybox
      curl
      lsd
      ripgrep

      # Hardware utils
      glxinfo
      pciutils
      usbutils
      powertop
      lm_sensors
      strace
      ltrace
      lsof
      sysstat
      cpufetch
      sbctl

      # Utils
      dconf-editor
      xorg.xhost

      python312
      python312Packages.nvidia-ml-py
      python312Packages.pynvml

      (prismlauncher.override {
        additionalLibs = [

        ];
        additionalPrograms = [
          glfw3-minecraft
          (if (hostname == "pc") then config.boot.kernelPackages.nvidiaPackages.boot else null)
          ffmpeg
        ];

        jdks = [
          graalvm-ce
          zulu8
          zulu17
          zulu
        ];
      })

    ];
  };
}
