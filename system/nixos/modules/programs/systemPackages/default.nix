{
  pkgs,
  lib,
  inputs,
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

      # Utils
      xorg.xhost

      inputs.quickshell.packages.${pkgs.system}.default
      qt6.qtdeclarative
      qt6.qt5compat
    ];
  };
}
