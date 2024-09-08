{
  services.gvfs.enable = true;
  systemd.oomd.enable = true;
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
  };
  services.openssh.enable = true;
}
