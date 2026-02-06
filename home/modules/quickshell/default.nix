{
  config,
  lib,
  pkgs,
  inputs,
  username,
  ...
}:

let
  cfg = config.module.quickshell;
  pkg = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system};
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.quickshell = {
    enable = mkEnableOption "Enable quickshell module";
  };

  config = mkIf cfg.enable {
    programs.quickshell = {
      enable = true;
      package =
        (pkg.default.override {
          debug = false;
          withCrashReporter = true;
          withJemalloc = true;
          withQtSvg = true;
          withWayland = true;
          withX11 = false;
          withPipewire = true;
          withPam = true;
          withHyprland = true;
          withI3 = false;
          withPolkit = false;
        }).passthru.withModules
          (with pkgs; [ qt6.qt5compat ]);

      systemd.enable = true;
      activeConfig = "/home/${username}/.config/quickshell";
    };
  };
}
