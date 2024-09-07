{ pkgs, ... }: {
  users.users.restranger = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "input" "networkmanager" ];
    hashedPassword = "$6$/k2DxKT/Biwenuzi$rxMb4alvs9KiBsfrI4UIiTWpTNYgvpvq8jGLl1thkTKX00APg6EPt1E9mO6DgpDHrOjwFWlmLwQiLcIk.w4o20";
  };
}
