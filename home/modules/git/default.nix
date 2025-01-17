{ config
, lib
, ...
}:

with lib;

let
  cfg = config.module.git;
in
{
  options.module.git = {
    enable = mkEnableOption "Enable git module";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      lfs.enable = true;
      userName = "ReStranger";
      userEmail = "restranger@disroot.org";
      extraConfig = {
        init.defaultBranch = "main";
        http = {
          postBuffer = 524288000;
          lowSpeedLimit = 0;
          lowSpeedTime = 999999;
        };
      };
    };
  };
}
