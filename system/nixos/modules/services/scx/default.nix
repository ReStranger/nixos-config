{
  lib,
  config,
  isLaptop,
  ...
}:

let
  cfg = config.module.services.scx;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.services.scx.enable = mkEnableOption "Enable scx";
  config = mkIf cfg.enable {
    services.scx = {
      enable = true;
      scheduler = "scx_lavd";
      extraArgs = [
        "--verbose"
        (if isLaptop then "--powersave" else "--performance")
      ];
    };
  };
}
