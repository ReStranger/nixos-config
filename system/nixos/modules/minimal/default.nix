{
  lib,
  config,
  ...
}:

let
  cfg = config.module.minimal;
  inherit (lib) mkEnableOption mkIf mkDefault;
in
{
  options = {
    module.minimal = {
      enable = mkEnableOption "Enables minimal";
    };
  };

  config = mkIf cfg.enable {
    # Disable dodocumentation
    documentation = {
      enable = mkDefault false;
      doc.enable = mkDefault false;
      info.enable = mkDefault false;
      man.enable = mkDefault false;
      nixos.enable = mkDefault false;
    };

    services.logrotate.enable = mkDefault false;
    programs.command-not-found.enable = mkDefault false;
  };
}
