{
  config,
  lib,
  ...
}: let
  cfg = config.module.services.kmscon;
  inherit (lib) mkEnableOption mkIf;
in {
  options.module.services.kmscon = {
    enable = mkEnableOption "Enable kmscon service";
  };

  config = mkIf cfg.enable {
    services.kmscon = {
      enable = true;
      useXkbConfig = true;
      config.hwaccel = true;
    };
  };
}
