{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.module.programs.systemPackages;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.programs.systemPackages.enable = mkEnableOption "Enable System Software";

  config = mkIf cfg.enable {
    programs.nano.enable = false;
    qt.enable = true;

    environment.systemPackages = with pkgs; [
      # Utils
      home-manager
      coreutils-full
      curl
      fd
      ripgrep
      nix-output-monitor

      # Utils
      xorg.xhost

      # HACK
      nautilus-open-any-terminal
    ];
    environment.pathsToLink = [
      "/share/zsh"
      "/share/nautilus-python/extensions"
    ];
  };
}
