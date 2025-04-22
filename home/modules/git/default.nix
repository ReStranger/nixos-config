{
  config,
  lib,
  ...
}:

let
  cfg = config.module.git;
  inherit (lib) mkEnableOption mkIf;

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
      difftastic.enable = true;
      extraConfig = {
        color.ui = true;
        init.defaultBranch = "main";
        safe.directory = "/etc/nixos";
        http = {
          postBuffer = 524288000;
          lowSpeedLimit = 0;
          lowSpeedTime = 999999;
        };
      };
    };
  };
}
