{ lib
, pkgs
, config
, ...
}:

with lib;

let
  cfg = config.module.programs.nix-ld;
in {
  options.module.programs.nix-ld.enable = mkEnableOption "Enable nix-ld";
  config = mkIf cfg.enable {
    programs = {
        nix-ld = {
          enable = true;
          libraries = with pkgs; [
            libxcrypt-legacy
            zlib
          ];
      };
    };
  };
}
