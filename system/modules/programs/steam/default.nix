{ lib
, config
, ...
}:

with lib;

let
  cfg = config.module.programs.steam;
in {
  options = {
    module.programs.steam = {
      enable = mkEnableOption "Enable steam client";
      proton-ge = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable proton-ge
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    steam = {
      enable = true;
      extraCompatPackages = 
      (
        if cfg.proton-ge then with pkgs; [
          proton-ge-bin
        ]
        else []
      );
    };
  };
}
