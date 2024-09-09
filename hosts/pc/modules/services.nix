{ pkgs, ... }:
{
  services = { 
    gvfs.enable = true;
      ananicy = {
        enable = true;
        package = pkgs.ananicy-cpp;
      };
    openssh.enable = true;
  };
  systemd.oomd.enable = true;
}
