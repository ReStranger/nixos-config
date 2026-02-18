{
  config,
  lib,
  ...
}:

let
  cfg = config.module.yazi;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.yazi = {
    enable = mkEnableOption "Enable yazi module";
  };

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "yy";
      settings = {
        mgr.show_symlink = true;
      };
    };
  };
}
