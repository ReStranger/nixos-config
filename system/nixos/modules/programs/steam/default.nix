{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.module.programs.steam;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.module.programs.steam = {
    enable = mkEnableOption "Enable steam client";
    proton-ge = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable proton-ge
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      extraCompatPackages =
        if cfg.proton-ge then
          with pkgs;
          [
            proton-ge-bin
          ]
        else
          [ ];
      protontricks.enable = true;
    };
  };
}
