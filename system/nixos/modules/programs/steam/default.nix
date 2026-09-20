{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.module.programs.steam;
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.module.programs.steam.enable = mkEnableOption "Enable steam client";

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      package = pkgs.millennium-steam;
      extraCompatPackages = with pkgs; [proton-ge-bin];
    };
  };
}
