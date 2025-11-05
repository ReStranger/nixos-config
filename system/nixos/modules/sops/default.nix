{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.module.sops;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.sops.enable = mkEnableOption "Enable sops module";
  config = mkIf cfg.enable {
    sops = {
      age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
      keepGenerations = 0;
    };
  };
}
