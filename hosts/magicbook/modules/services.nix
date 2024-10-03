{ ... }:
{
  services = { 
    gvfs.enable = true;
    openssh.enable = true;
    zerotierone = {
      enable = true;
      joinNetworks = [
        "0cccb752f7c9e833"
      ];
    };
    flatpak.enable = true;
  };
  systemd.oomd.enable = true;
}
