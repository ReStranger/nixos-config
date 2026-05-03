{
  config,
  lib,
  ...
}: let
  cfg = config.module.direnv;
  inherit (lib) mkEnableOption mkIf;
in {
  options.module.direnv = {
    enable = mkEnableOption "Enable direnv program";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      silent = true;
      nix-direnv.enable = true;
    };
  };
}
