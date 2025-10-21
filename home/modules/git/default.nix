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
    programs = {
      difftastic.enable = true;
      git = {
        enable = true;
        settings = {
          user = {
            name = "ReStranger";
            email = "restranger@disroot.org";
          };
          lfs.enable = true;
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
  };
}
