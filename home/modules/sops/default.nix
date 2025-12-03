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
    home.packages = with pkgs; [
      sops
      age
    ];
    sops = {
      age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
      defaultSopsFile = "${self}/secrets/home/${username}/secrets.yaml";
      keepGenerations = 0;
    };
  };
}
