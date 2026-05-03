{
  config,
  lib,
  ...
}: let
  cfg = config.module.qt;
  inherit (lib) mkEnableOption mkIf;
in {
  options.module.qt = {
    enable = mkEnableOption "Enable qt module";
  };

  config = mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "kvantum";
    };
  };
}
