{ lib
, config
, pkgs
, ...
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
        FWTYPE=nftables
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
        DESYNC_MARK=0x40000000
        DESYNC_MARK_POSTNAT=0x20000000

        TPWS_SOCKS_ENABLE=0
        TPPORT_SOCKS=987
        TPWS_SOCKS_OPT="
        --filter-tcp=80 --methodeol <HOSTLIST> --new
        --filter-tcp=443 --split-pos=1,midsld --disorder <HOSTLIST>
        "

        TPWS_ENABLE=0
        TPWS_PORTS=80,443
        TPWS_OPT="
        --filter-tcp=80 --methodeol <HOSTLIST> --new
        --filter-tcp=443 --split-pos=1,midsld --disorder <HOSTLIST>
        "

        NFQWS_ENABLE=1
        NFQWS_PORTS_TCP="$(echo $NFQWS_OPT | grep -oE 'filter-tcp=[0-9,-]+' | sed -e 's/.*=//g' -e 's/,/\n/g' | sort -un)";
        NFQWS_PORTS_UDP="$(echo $NFQWS_OPT | grep -oE 'filter-udp=[0-9,-]+' | sed -e 's/.*=//g' -e 's/,/\n/g' | sort -un)";
        NFQWS_TCP_PKT_OUT=$((6+$AUTOHOSTLIST_RETRANS_THRESHOLD))
        NFQWS_TCP_PKT_IN=3
        NFQWS_UDP_PKT_OUT=$((6+$AUTOHOSTLIST_RETRANS_THRESHOLD))
        NFQWS_UDP_PKT_IN=0
        NFQWS_OPT="
        --filter-tcp=80 --dpi-desync=fake,split2 --dpi-desync-fooling=md5sig <HOSTLIST_NOAUTO> --new
        --filter-tcp=443 --dpi-desync=fake,disorder2 --dpi-desync-fooling=md5sig <HOSTLIST_NOAUTO> --new
        --filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=6 <HOSTLIST_NOAUTO> --new
        --filter-udp=50000-50099 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-fake-quic=0xC3
        "

        MODE_FILTER=autohostlist

        FLOWOFFLOAD=donttouch

        INIT_APPLY_FW=1

        DISABLE_IPV6=1
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
      default = "nftables";
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
  };
  config = mkIf cfg.enable {
    boot.kernel.sysctl = { "net.netfilter.nf_conntrack_tcp_be_liberal" = 1; };
    users.users.tpws = {
      isSystemUser = true;
      group = "tpws";
    };
    users.groups.tpws = { };
    systemd.services.zapret-config = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [
        (if cfg.firewallType == "iptables" then iptables else nftables)
        gawk
        ipset
        sysctl
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
