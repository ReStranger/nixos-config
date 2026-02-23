{ config, lib, ... }:

let
  cfg = config.module.services.disableWantedBy;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkMerge
    mkForce
    ;
  inherit (lib.types) listOf str;
in
{
  options.module.services.disableWantedBy = {
    enable = mkEnableOption "Disable WantedBy for services";
    services = mkOption {
      type = listOf str;
      default = [ ];
      example = [
        "foo"
        "too"
      ];
      description = "List of systemd service names for which wantedBy will be forced to [].";
    };
  };

  config = mkIf cfg.enable {
    systemd.services = mkMerge (
      map (name: {
        ${name}.wantedBy = mkForce [ ];
      }) cfg.services
    );
  };
}
