{ ... }:
{
  services = { 
    gvfs.enable = true;
    openssh.enable = true;
    zerotierone = {
      enable = true;
      joinNetworks = [
        "e3918db48305d83a"
      ];
    };
    flatpak.enable = true;
  };
  systemd.oomd.enable = true;
}
