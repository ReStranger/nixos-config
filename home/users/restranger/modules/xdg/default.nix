{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta.meta.desktopFileName;
  editor = "nvim.desktop";
  imageViewer = "org.gnome.eog.desktop";
  videoPlayer = "vlc.desktop";
  fileManager = "org.gnome.Nautilus.desktop";
  pdfReader = "org.pwmt.zathura.desktop";
  torrent = "transmission-gtk.desktop";
  mail = "Thunderbird.desktop";
  wine = "PortProton.desktop";

  mimeBrowser = [
    "application/x-extension-shtml"
    "application/x-extension-xhtml"
    "application/x-extension-html"
    "application/x-extension-xht"
    "application/x-extension-htm"
    "x-scheme-handler/unknown"
    "x-scheme-handler/mailto"
    "x-scheme-handler/chrome"
    "x-scheme-handler/about"
    "x-scheme-handler/https"
    "x-scheme-handler/http"
    "application/xhtml+xml"
    "application/json"
    "text/html"
  ];

  mimeFigma = [
    "x-scheme-handler/figma"
  ];

  mimeFileManager = [
    "inode/directory"
    "application/x-gnome-saved-search"
  ];

  mimeEditor = [
    "text/markdown"
    "text/plain"
  ];

  mimeImageViewer = [
    "image/png"
    "image/jpeg"
    "image/jpg"
    "image/svg+xml"
  ];

  mimeVideoPlayer = [
    "image/gif"
    "video/mp4"
  ];

  mimePdfReader = [
    "application/pdf"
  ];

  mimeTelegram = [
    "x-scheme-handler/tg"
    "x-scheme-handler/tonsite"
  ];

  mimeObsidian = [
    "x-scheme-handler/obsidian"
  ];

  mimeAnytype = [
    "x-scheme-handler/anytype"
  ];

  mimeTorrent = [
    "x-scheme-handler/magnet"
  ];

  mimeMail = [
    "x-scheme-handler/mailto"
    "message/rfc822"
    "x-scheme-handler/mid"
  ];

  mimeWine = [
    "application/vnd.microsoft.portable-executable"
    "application/x-msi"
  ];

  mkAssociations =
    names: desktopFile:
    builtins.listToAttrs (
      map (name: {
        inherit name;
        value = desktopFile;
      }) names
    );

  browserApps = mkAssociations mimeBrowser browser;
  figmaApps = mkAssociations mimeFigma "figma-linux.desktop";
  fileManagerApps = mkAssociations mimeFileManager fileManager;
  editorApps = mkAssociations mimeEditor editor;
  imageViewerApps = mkAssociations mimeImageViewer imageViewer;
  videoPlayerApps = mkAssociations mimeVideoPlayer videoPlayer;
  pdfReaderApps = mkAssociations mimePdfReader pdfReader;

  telegramApps = mkAssociations mimeTelegram "com.ayugram.desktop.desktop";
  obsidianApps = mkAssociations mimeObsidian "obsidian.desktop";
  anytypeApps = mkAssociations mimeAnytype "anytype.desktop";
  transmissionApps = mkAssociations mimeTorrent torrent;
  thunderbirdApps = mkAssociations mimeMail mail;
  portprotonApps = mkAssociations mimeWine wine;

  associations =
    browserApps
    // figmaApps
    // fileManagerApps
    // editorApps
    // imageViewerApps
    // videoPlayerApps
    // pdfReaderApps
    // telegramApps
    // obsidianApps
    // anytypeApps
    // transmissionApps
    // thunderbirdApps
    // portprotonApps;

in
{
  options.module.user.xdg.enable = mkEnableOption "Enable xdg";

  config = mkIf config.module.user.xdg.enable {
    xdg.mimeApps = {
      enable = true;
      defaultApplications = associations;
      associations.added = associations;
    };
  };
}
