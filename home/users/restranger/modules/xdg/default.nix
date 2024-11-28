{ config
, lib
, ...
}:

with lib;

let
  cfg = config.module.user.xdg;
in
{
  options = {
    module.user.xdg.enable = mkEnableOption "Enables xdg";
  };

  config = mkIf cfg.enable {
    xdg.mimeApps = {
      enable = true;

      defaultApplications = {

        "inode/directory" = "nemo.desktop";
        "application/x-gnome-saved-search" = "nemo.desktop";

        "text/markdown" = "nvim.desktop";
        "text/plain" = "nvim.desktop";

        "text/html" = "firefox-developer-edition.desktop";
        "x-scheme-handler/http" = "firefox-developer-edition.desktop";
        "x-scheme-handler/https" = "firefox-developer-edition.desktop";
        "x-scheme-handler/about" = "firefox-developer-edition.desktop";
        "x-scheme-handler/unknown" = "firefox-developer-edition.desktop";

        "image/png" = "imv.desktop";
        "image/jpeg" = "imv.desktop";
        "image/jpg" = "imv.desktop";
        "image/svg+xml" = "imv.desktop";

        "image/gif" = "mpv.desktop";
        "video/mp4" = "mpv.desktop";

        "application/pdf" = "org.pwmt.zathura.desktop";

        "x-scheme-handler/tg" = "com.ayugram.desktop.desktop";
        "x-scheme-handler/tonsite" = "com.ayugram.desktop.desktop";


        "x-scheme-handler/obsidian" = "obsidian.desktop";
        "x-scheme-handler/anytype" = "anytype.desktop";

        "x-scheme-handler/magnet" = "userapp-transmission-gtk-UCJKV2.desktop";
        "x-scheme-handler/mailto" = "userapp-Thunderbird-QT8EW2.desktop";
        "message/rfc822" = "userapp-Thunderbird-QT8EW2.desktop";
        "x-scheme-handler/mid" = "userapp-Thunderbird-QT8EW2.desktop";

      };
    };
  };
}
