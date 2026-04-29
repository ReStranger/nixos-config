{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.module.services.ananicy;
  inherit (lib) mkEnableOption mkIf;
in {
  options.module.services.ananicy = {
    enable = mkEnableOption "Enable ananicy service";
  };

  config = mkIf cfg.enable {
    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
  };
}
