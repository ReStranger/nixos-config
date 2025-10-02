{
  pkgs,
  lib,
  config,
  username,
  ...
}:

let
  cfg = config.module.users;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.module.users = {
    enable = mkEnableOption "Enables users";
    ${username}.hashedPassword = mkOption {
      type = types.str;
      default = false;
      description = ''
        Set hashed password to ${username}
      '';
    };
    root.hashedPassword = mkOption {
      type = types.str;
      default = false;
      description = ''
        Set hashed password to root
      '';
    };
  };
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
          hashedPassword = cfg.${username}.hashedPassword;
          # hashedPassword = "$6$/k2DxKT/Biwenuzi$rxMb4alvs9KiBsfrI4UIiTWpTNYgvpvq8jGLl1thkTKX00APg6EPt1E9mO6DgpDHrOjwFWlmLwQiLcIk.w4o20";

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
          hashedPassword = cfg.root.hashedPassword;
          # hashedPassword = "$6$/k2DxKT/Biwenuzi$rxMb4alvs9KiBsfrI4UIiTWpTNYgvpvq8jGLl1thkTKX00APg6EPt1E9mO6DgpDHrOjwFWlmLwQiLcIk.w4o20";
        };
      };
    };
  };
}
