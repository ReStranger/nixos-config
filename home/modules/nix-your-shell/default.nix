{
  config,
  lib,
  ...
}: let
  cfg = config.module.nix-your-shell;
  inherit (lib) mkEnableOption mkIf;
in {
  options.module.nix-your-shell = {
    enable = mkEnableOption "Enable nix-your-shell module";
  };

  config = mkIf cfg.enable {
    programs.nix-your-shell = {
      enable = true;
      nix-output-monitor.enable = true;
    };
  };
}
