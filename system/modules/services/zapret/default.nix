{ lib
, config
, ...
}:
with lib;
let
  cfg = config.module.services.zapret;
in
{
  options.module.services.zapret.enable = mkEnableOption "DPI bypass multi platform service";
  config = mkIf cfg.enable {
    services.zapret = {
      enable = true;
      qnum = 200;
      httpSupport = true;
      configureFirewall = false;
      whitelist = [
        "rutracker.org"
        "rutracker.cc"
        "hentai.tv"
        "pornhub.com"
        "nhplayer.com"
        "1hanime.com"
        "youtube.com"
        "youtu.be"
        "yt.be"
        "googlevideo.com"
        "ytimg.com"
        "ggpht.com"
        "gvt1.com"
        "youtube-nocookie.com"
        "youtube-ui.l.google.com"
        "youtubeembeddedplayer.googleapis.com"
        "youtube.googleapis.com"
        "youtubei.googleapis.com"
        "yt-video-upload.l.google.com"
        "wide-youtube.l.google.com"
        "discord.com"
        "gateway.discord.gg"
        "cdn.discordapp.com"
        "discordapp.net"
        "discordapp.com"
        "discord.gg"
        "media.discordapp.net"
        "images-ext-1.discordapp.net"
        "discord.app"
        "discord.media"
        "discordcdn.com"
        "discord.dev"
        "discord.new"
        "discord.gift"
        "discordstatus.com"
        "dis.gd"
        "discord.co"
        "discord-attachments-uploads-prd.storage.googleapis.com"
      ];
      params = [
        "--filter-tcp=80 --dpi-desync=fake,split2"
        "--dpi-desync-fooling=md5sig"
        "<HOSTLIST_NOAUTO>"
        "--new"
        "--filter-tcp=443"
        "--dpi-desync=fake,disorder2"
        "--dpi-desync-fooling=md5sig"
        "<HOSTLIST_NOAUTO>"
        "--new"
        "--filter-udp=443"
        "--dpi-desync=fake"
        "--dpi-desync-repeats=6"
        "<HOSTLIST_NOAUTO>"
        "--new"
        "--filter-udp=50000-50099"
        "--dpi-desync=fake"
        "--dpi-desync-any-protocol"
        "--dpi-desync-fake-quic=0xC3"
      ];
    };
  };
}
