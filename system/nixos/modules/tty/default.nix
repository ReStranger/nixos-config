{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.module.tty;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.tty.enable = mkEnableOption "Enable TTY setup module";
  config = mkIf cfg.enable {
    console = {
      earlySetup = true;
      font = "ter-v32n";
      packages = with pkgs; [ terminus_font ];
      keyMap = "us";
    };
  };
}
