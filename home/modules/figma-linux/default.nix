{ config
, lib
, ...
}:

with lib;

let
  cfg = config.module.figma-linux;
in {
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

