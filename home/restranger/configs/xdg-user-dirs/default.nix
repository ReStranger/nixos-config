{
  environment.etc = {
    "xdg/user-dirs.defaults".text = ''
      XDG_DOCUMENTS_DIR="$HOME/Documents"
      XDG_MUSIC_DIR="$HOME/Music"
      XDG_PICTURES_DIR="$HOME/Pictures"
      XDG_VIDEOS_DIR="$HOME/Videos"
      XDG_DOWNLOAD_DIR="$HOME/Downloads"
      XDG_DESKTOP_DIR="$HOME/"
      XDG_TEMPLATES_DIR="$HOME/"
      XDG_PUBLICSHARE_DIR="$HOME/"
    '';
  };

}
