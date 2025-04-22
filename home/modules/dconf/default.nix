{
  config,
  lib,
  ...
}:

let
  cfg = config.module.dconf;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.dconf = {
    enable = mkEnableOption "Enable dconf module";
  };

  config = mkIf cfg.enable {
    dconf = {
      enable = true;
      settings."org/gnome/desktop/wm/preferences" = {
        button-layout = "";
      };
    };
  };
}
