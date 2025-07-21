{
  config,
  lib,
  ...
}:

let
  cfg = config.module.user.xdg;
  inherit (lib) mkEnableOption mkIf;
in
{
  options = {
    module.user.xdg.enable = mkEnableOption "Enables xdg";
  };

  config = mkIf cfg.enable {
    xdg.mimeApps = {
      enable = true;

      defaultApplications = {

        "inode/directory" = "org.gnome.Nautilus.desktop";
        "application/x-gnome-saved-search" = "org.gnome.Nautilus.desktop";

        "text/markdown" = "nvim.desktop";
        "text/plain" = "nvim.desktop";

        "text/html" = "zen-beta.desktop";
        "x-scheme-handler/http" = "zen-beta.desktop";
        "x-scheme-handler/https" = "zen-beta.desktop";
        "x-scheme-handler/about" = "zen-beta.desktop";
        "x-scheme-handler/unknown" = "zen-beta.desktop";

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
