{ inputs
, lib
, config
, ...
}:

with lib;

let
  cfg = config.module.programs.home-manager;
in
{
  options.module.programs.home-manager.enable = mkEnableOption "Enable Home Manager";

  config = mkIf cfg.enable {
    home-manager = {
      # useGlobalPkgs = true;
      # useUserPackages = true; 
      extraSpecialArgs = {
        inherit inputs;
      };
    };
  };
}
