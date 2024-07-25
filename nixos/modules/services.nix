{
  services.gvfs.enable = true;
  services.openssh.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.power-profiles-daemon = {
  enable = true;
  };
}
