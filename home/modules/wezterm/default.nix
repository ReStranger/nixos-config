{ config
, lib
, inputs
, pkgs
, ...
}:

with lib;

let
  cfg = config.module.wezterm;
in {
  options.module.wezterm = {
    enable = mkEnableOption "Enable wezterm module";
  };

  config = mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      package = inputs.wezterm.packages.${pkgs.system}.default;
      extraConfig = ''
      '';
    };
  };
}
