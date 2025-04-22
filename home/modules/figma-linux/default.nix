{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.module.figma-linux;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.figma-linux = {
    enable = mkEnableOption "Enable figma-linux module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      figma-linux
      figma-agent
    ];
  };
}
