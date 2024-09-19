{ pkgs, ... }:
{
  services = { 
    gvfs.enable = true;
      ananicy = {
        enable = true;
        package = pkgs.ananicy-cpp;
      };
    openssh.enable = true;
    zerotierone = {
      enable = true;
      joinNetworks = [
        "0cccb752f7c9e833"
      ];
    };
    flatpak.enable = true;
  };
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];
  systemd.oomd.enable = true;
}
