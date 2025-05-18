{
  lib,
  config,
  ...
}:

let
  cfg = config.module.programs.zsh;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.programs.zsh.enable = mkEnableOption "Enable zsh";

  config = mkIf cfg.enable {
    programs.zsh.enable = true;
  };
}
