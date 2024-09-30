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
        "0cccb752f7c9e833"
      ];
    };
    flatpak.enable = true;
  };
  systemd.oomd.enable = true;
}
