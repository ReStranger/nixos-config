{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.module.services.flatpak;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.services.flatpak.enable = mkEnableOption "Enable flatpak";
  config = mkIf cfg.enable {
    services.flatpak.enable = true;
    systemd.services.flatpak-repo = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };
  };
}
