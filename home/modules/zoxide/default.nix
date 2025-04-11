{ config
, lib
, ...
}:

let
  cfg = config.module.zoxide;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.zoxide.enable = mkEnableOption "Enable zoxide module";

  config = mkIf cfg.enable {
    programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
    };
  };
}
