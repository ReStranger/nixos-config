{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  services.libinput.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

}
