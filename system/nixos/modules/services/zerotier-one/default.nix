{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.module.services.zerotier-one;
  inherit (lib) mkEnableOption mkOption mkIf;
  inherit (lib.types) listOf str;
in
{
  options.module.services.zerotier-one = {
    enable = mkEnableOption "Enable zerotier-one";
    joinNetworks = mkOption {
      default = [ ];
      example = [ "a8a2c3c10c1a68de" ];
      type = listOf str;
      description = ''
        List of ZeroTier Network IDs to join on startup.
        Note that networks are only ever joined, but not automatically left after removing them from the list.
        To remove networks, use the ZeroTier CLI: `zerotier-cli leave <network-id>`
      '';
    };
  };
  config = mkIf cfg.enable {
    services.zerotierone = {
      enable = true;
      inherit (cfg) joinNetworks;
    };
    sops.secrets = {
      "zerotier-one/identity/public" = {
        owner = "root";
        group = "root";
        mode = "0644";
      };
      "zerotier-one/identity/secret" = {
        owner = "root";
        group = "root";
        mode = "0600";
      };
    };

    environment.etc."zerotier-one/identity.public".source =
      config.sops.secrets."zerotier-one/identity/public".path;
    environment.etc."zerotier-one/identity.secret".source =
      config.sops.secrets."zerotier-one/identity/secret".path;

    systemd.services.zerotier-key-sync = {
      description = "Sync zerotier keys from /etc to /var/lib";
      before = [ "zerotierone.service" ];
      wantedBy = [ "zerotierone.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.writeShellScript "zerotier-one-key-sync.sh" ''
          cp -f /etc/zerotier-one/identity.public /var/lib/zerotier-one/identity.public
          cp -f /etc/zerotier-one/identity.secret /var/lib/zerotier-one/identity.secret
          chown root:root /var/lib/zerotier-one/identity.*
          chmod 0644 /var/lib/zerotier-one/identity.public
          chmod 0600 /var/lib/zerotier-one/identity.secret
        ''}";
      };
    };
  };
}
