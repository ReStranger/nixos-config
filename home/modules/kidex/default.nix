{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.module.kidex;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.kidex = {
    enable = mkEnableOption "Enable kidex service";
  };

  config = mkIf cfg.enable {
    services.kidex = {
      enable = true;
      package = inputs.kidex.packages.${pkgs.system}.kidex;
      settings = {
        directories = [
          {
            path = "~/Develop";
            recurse = true;
          }
          {
            path = "~/Documents";
            recurse = true;
          }
          {
            path = "~/Downloads";
            recurse = false;
          }
          {
            path = "~/Music";
            recurse = true;
          }
          {
            path = "~/Pictures";
            recurse = true;
          }
          {
            path = "~/Videos";
            recurse = true;
          }
        ];
      };
    };
  };
}
