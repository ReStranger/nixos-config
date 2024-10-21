{ lib
  , config
  , pkgs
  , ...
}:
with lib;
let
  cfg = config.services.zapret;
in {
  options.modules.tty = {
    enable = mkEnableOption "Enable TTY setup module";
  };
  config = mkIf cfg.enable {
    console = {
      earlySetup = true;
      font = "ter-v32n";
      packages = with pkgs; [ terminus_font ];
      keyMap = "us";
    };
  };
}
