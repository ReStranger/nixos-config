{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.module.programs.nix-ld;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.programs.nix-ld.enable = mkEnableOption "Enable nix-ld";
  config = mkIf cfg.enable {
    programs = {
      nix-ld = {
        enable = true;
        libraries = with pkgs; [
          libxcrypt-legacy
          zlib
          libcxx
          readline
          iconv
          iconv.dev
        ];
      };
    };
  };
}
