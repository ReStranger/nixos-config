{
  config,
  inputs,
  lib,
  ...
}:

let
  cfg = config.module.nix;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.nix = {
    enable = mkEnableOption "Enable nix module";
  };

  config = mkIf cfg.enable {
    nix = {
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    };
  };
}
