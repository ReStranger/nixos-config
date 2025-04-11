{ config
, lib
, ...
}:

with lib;

let
  cfg = config.module.yazi;
in
{
  options.module.yazi = {
    enable = mkEnableOption "Enable yazi module";
  };

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        manager.show_symlink = true;
      };
    };
  };
}
