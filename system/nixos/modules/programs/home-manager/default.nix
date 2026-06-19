{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.module.programs.home-manager;
  inherit (lib) mkEnableOption mkIf;
in {
  options.module.programs.home-manager.enable = mkEnableOption "Enable Home Manager";

  config = mkIf cfg.enable {
    home-manager = {
      # useGlobalPkgs = true;
      # useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs;
        stable = inputs.stable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        unstable = inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        master = inputs.master.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      };
    };
  };
}
