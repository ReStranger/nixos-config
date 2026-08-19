{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.module.fzf;
  inherit (lib) mkEnableOption mkIf mkForce getExe;
in {
  options.module.fzf = {
    enable = mkEnableOption "Enable fzf module";
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      colors.bg = mkForce "-1";
      defaultOptions = ["--border"];
      fileWidget.options = [
        "--preview '${getExe pkgs.bat} --color=always --style=numbers --line-range=:500 {}'"
      ];
    };
  };
}
