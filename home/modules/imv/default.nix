{
  config,
  lib,
  ...
}: let
  cfg = config.module.imv;
  inherit (lib) mkEnableOption mkIf;
  inherit (config.lib.stylix.colors.withHashtag) base00;
in {
  options.module.imv = {
    enable = mkEnableOption "Enable imv module";
  };

  config = mkIf cfg.enable {
    programs.imv = {
      enable = true;
      settings = {
        options = {
          background = base00;
        };
      };
    };
  };
}
