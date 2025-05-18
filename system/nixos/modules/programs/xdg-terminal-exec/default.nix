{
  config,
  lib,
  ...
}:

let
  cfg = config.module.programs.xdg-terminal-exec;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.programs.xdg-terminal-exec = {
    enable = mkEnableOption "Enable xdg-terminal-exec program";
  };

  config = mkIf cfg.enable {
    xdg.terminal-exec.enable = true;
  };
}
