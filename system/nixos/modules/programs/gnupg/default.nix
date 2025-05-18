{
  lib,
  config,
  ...
}:

let
  cfg = config.module.programs.gnupg;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.programs.gnupg.enable = mkEnableOption "Enables GnuPG";
  config = mkIf cfg.enable {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
