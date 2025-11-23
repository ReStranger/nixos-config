{
  lib,
  config,
  ...
}:

let
  cfg = config.module.programs.throne;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.programs.throne = {
    enable = mkEnableOption "Enable throne";
  };

  config = mkIf cfg.enable {
    programs.throne = {
      enable = true;
      tunMode.enable = true;
    };
  };
}
