{ pkgs, ... }:
{
  services = { 
    gvfs.enable = true;
      # ananicy = {
      #   enable = true;
      #   package = pkgs.ananicy-cpp;
      # };
    openssh.enable = true;
    zerotierone = {
      enable = true;
      joinNetworks = [
        "e3918db48305d83a"
      ];
    };
    flatpak.enable = true;
    zapret = {
      enable = true;
      params = [
        "--qnum=0"
        "--dpi-desync=fake"
        "--dpi-desync-ttl=0"
        "--dpi-desync-ttl6=0"
        "--dpi-desync-fooling=badsum"
        "--hostlist-auto-retrans-threshold=3"
        "--hostlist-auto-fail-threshold=3"
        "--hostlist-auto-fail-time=60"
        "--dpi-desync-repeats=6"
        "--dpi-desync-any-protocol"
        "--dpi-desync-udplen-increment=10"
        "--dpi-desync-udplen-pattern=0xDEADBEEF"
        "--new"
        "--filter-udp=50000-65535" 
        "--dpi-desync=fake,tamper"
        "--new"
        "--filter-tcp=443" 
        "--dpi-desync=fake,split2" 
        "--dpi-desync-autottl=2" 
        "--dpi-desync-fooling=md5sig"
        ];
      whitelist = [
          "discord-attachments-uploads-prd.storage.googleapis.com"
          "dis.gd"
          "discord.co"
          "discord.com"
          "discord.design"
          "discord.dev"
          "discord.gg"
          "discord.gift"
          "discord.gifts"
          "discord.media"
          "discord.new"
          "discord.store"
          "discord.tools"
          "discordapp.com"
          "discordapp.net"
          "discordmerch.com"
          "discordpartygames.com"
          "discord-activities.com"
          "discordactivities.com"
          "discordsays.com"
        ];
      };
    };
    systemd.oomd.enable = true;
  }
