{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.module.services.zapret-config;
in
{
  options.module.services.zapret-config = {
    enable = mkEnableOption "DPI bypass multi platform service";
    package = mkPackageOption pkgs "zapret" { };
    settings = mkOption {
      type = types.lines;
      default = ''
        SET_MAXELEM=522288
        IPSET_OPT="hashsize 262144 maxelem $SET_MAXELEM"

        IP2NET_OPT4="--prefix-length=22-30 --v4-threshold=3/4"
        IP2NET_OPT6="--prefix-length=56-64 --v6-threshold=5"
        AUTOHOSTLIST_RETRANS_THRESHOLD=3
        AUTOHOSTLIST_FAIL_THRESHOLD=3
        AUTOHOSTLIST_FAIL_TIME=60
        AUTOHOSTLIST_DEBUGLOG=0

        MDIG_THREADS=30

        GZIP_LISTS=1
        QUIC_PORTS=50000-65535

        MODE_HTTP=1
        MODE_HTTP_KEEPALIVE=0
        MODE_HTTPS=1
        MODE_QUIC=1
        MODE_FILTER=none

        DESYNC_MARK=0x40000000
        DESYNC_MARK_POSTNAT=0x20000000
        NFQWS_OPT_DESYNC="--dpi-desync=fake --dpi-desync-ttl=0 --dpi-desync-ttl6=0 --dpi-desync-fooling=badsum"
        NFQWS_OPT_DESYNC_HTTP="--dpi-desync=split --dpi-desync-ttl=5"
        NFQWS_OPT_DESYNC_HTTPS="--dpi-desync=fake --dpi-desync-ttl=5"
        NFQWS_OPT_DESYNC_QUIC="--dpi-desync=fake,tamper --dpi-desync-repeats=6 --dpi-desync-any-protocol"

        TPWS_OPT="--hostspell=HOST --split-http-req=method --split-pos=3 --hostcase --oob"

        FLOWOFFLOAD=donttouch

        INIT_APPLY_FW=1

        DISABLE_IPV6=1

        GETLIST=get_antifilter_ipsmart.sh
      '';
      example = ''
        TPWS_OPT="--hostspell=HOST --split-http-req=method --split-pos=3 --oob"
        NFQWS_OPT_DESYNC="--dpi-desync-ttl=5"
      '';
      description = ''
        Rules for zapret to work. Run ```nix-shell -p zapret --command blockcheck``` to get values to pass here.
        Config example can be found here https://github.com/bol-van/zapret/blob/master/config.default
      '';
    };
    firewallType = mkOption {
      type = types.enum [
        "iptables"
        "nftables"
      ];
      default = "iptables";
      description = ''
        Which firewall zapret should use
      '';
    };
    disableIpv6 = mkOption {
      type = types.bool;
      # recommended by upstream
      default = true;
      description = ''
        Disable or enable usage of IpV6 by zapret
      '';
    };
    mode = mkOption {
      type = types.enum [
        "tpws"
        "tpws-socks"
        "nfqws"
        "filter"
        "custom"
      ];
      default = "nfqws";
      description = ''
        Which mode zapret should use
      '';
    };
  };
  config = mkIf cfg.enable {
    users.users.tpws = {
      isSystemUser = true;
      group = "tpws";
    };
    users.groups.tpws = { };
    systemd.services.zapret = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [
        (if cfg.firewallType == "iptables" then iptables else nftables)
        gawk
        ipset
      ];
      serviceConfig = {
        Type = "forking";
        Restart = "no";
        TimeoutSec = "30sec";
        IgnoreSIGPIPE = "no";
        KillMode = "none";
        GuessMainPID = "no";
        RemainAfterExit = "no";
        ExecStart = "${cfg.package}/bin/zapret start";
        ExecStop = "${cfg.package}/bin/zapret stop";
        EnvironmentFile = pkgs.writeText "${cfg.package.pname}-environment" (concatStrings [
          ''
            MODE=${cfg.mode}
            FWTYPE=${cfg.firewallType}
            DISABLE_IPV6=${if cfg.disableIpv6 then "1" else "0"}
          ''
          cfg.settings
        ]);
        # hardening
        DevicePolicy = "closed";
        KeyringMode = "private";
        PrivateTmp = true;
        PrivateMounts = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        ProtectProc = "invisible";
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
      };
    };
    meta.maintainers = with maintainers; [ nishimara ];
  };
}
