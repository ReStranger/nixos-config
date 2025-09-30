{
  self,
  config,
  pkgs,
  lib,
  username,
  ...
}:

let
  cfg = config.module.sops;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.sops = {
    enable = mkEnableOption "Enable sops module";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.sops ];
    sops = {
      age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
      keepGenerations = 0;

      secrets = {
        "openai_key" = {
          sopsFile = "${self}/secrets/home/${username}/secrets.yaml";
        };
      };
    };
  };
}
