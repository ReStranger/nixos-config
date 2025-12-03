{
  self,
  pkgs,
  lib,
  config,
  username,
  hostname,
  ...
}:

let
  cfg = config.module.users;
  inherit (lib)
    mkEnableOption
    mkIf
    genAttrs
    ;
in
{
  options.module.users.enable = mkEnableOption "Enables users";

  config =
    let
      userNames = [
        "${username}"
        "root"
      ];
    in
    mkIf cfg.enable {
      sops.secrets =
        let
          sopsFile = "${self}/secrets/system/${hostname}/secrets.yaml";
        in
        genAttrs (map (u: "user_password/${u}") userNames) (_up: {
          neededForUsers = true;
          inherit sopsFile;
        });

      users = {
        mutableUsers = false;

        groups = {
          "${username}" = {
            gid = 1000;
          };
        };

        users = genAttrs userNames (
          u:
          let
            common = {
              shell = pkgs.zsh;
              hashedPasswordFile = config.sops.secrets."user_password/${u}".path;
            };
          in
          if u == "${username}" then
            common
            // {
              uid = 1000;
              isNormalUser = true;
              description = "${username}";
              extraGroups = [
                "audio"
                "networkmanager"
                "wheel"
                "docker"
                "libvirtd"
                "dialout"
              ];
            }
          else
            common
        );
      };
    };
}
