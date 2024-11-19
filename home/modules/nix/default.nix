{ config
, inputs
, lib
, ...
}:

with lib;

let
  cfg = config.module.nix;
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
