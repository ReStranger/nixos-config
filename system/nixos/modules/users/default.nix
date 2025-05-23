{
  pkgs,
  lib,
  config,
  username,
  ...
}:

let
  cfg = config.module.users;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.users.enable = mkEnableOption "Enables users";
  config = mkIf cfg.enable {
    users = {
      mutableUsers = false;

      groups = {
        ${username} = {
          gid = 1000;
        };
      };

      users = {
        ${username} = {
          uid = 1000;
          home = "/home/${username}";
          shell = pkgs.zsh;
          group = "${username}";
          createHome = true;
          description = "${username}";
          isSystemUser = true;
          hashedPassword = "$6$/k2DxKT/Biwenuzi$rxMb4alvs9KiBsfrI4UIiTWpTNYgvpvq8jGLl1thkTKX00APg6EPt1E9mO6DgpDHrOjwFWlmLwQiLcIk.w4o20";

          extraGroups = [
            "audio"
            "networkmanager"
            "wheel"
            "docker"
            "libvirtd"
            "dialout"
          ];
        };

        root = {
          shell = pkgs.zsh;
          hashedPassword = "$6$/k2DxKT/Biwenuzi$rxMb4alvs9KiBsfrI4UIiTWpTNYgvpvq8jGLl1thkTKX00APg6EPt1E9mO6DgpDHrOjwFWlmLwQiLcIk.w4o20";
        };
      };
    };
  };
}
