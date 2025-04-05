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
      coreutils
      curl
      lsd
      ripgrep

      # Hardware utils
      cpufetch

      # Utils
      dconf-editor
      xorg.xhost

      (prismlauncher.override {
        additionalPrograms = [
          glfw3-minecraft
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
