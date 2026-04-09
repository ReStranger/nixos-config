{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.module.cachix;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.cachix = {
    enable = mkEnableOption "Enable cachix module";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.cachix ];

    sops.secrets."cachix_auth_token" = { };

    sops.templates."cachix-config" = {
      path = ".config/cachix/cachix.nix";
      content = ''
        {
          re-cache = {
            authToken = "${config.sops.placeholder."cachix_auth_token"}";
          };
        }
      '';
    };
  };
}
