{
  config,
  lib,
  ...
}:

let
  cfg = config.module.starship;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.starship = {
    enable = mkEnableOption "Enable starship module";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
