{ config
, lib
, ...
}:

let
  cfg = config.module.fzf;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.fzf.enable = mkEnableOption "Enable fzf module";

  config = mkIf cfg.enable {
    programs.fzf = {
        enable = true;
        enableZshIntegration = true;
    };
  };
}
