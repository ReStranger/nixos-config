{
  self,
  inputs,
  lib,
  config,
  options,
  username,
  ...
}: let
  cfg = config.module.nix-config;
  inherit
    (lib)
    mkEnableOption
    mkForce
    mkIf
    mkOption
    optionalAttrs
    ;
  inherit (lib.types) bool;
in {
  options = {
    module.nix-config = {
      enable = mkEnableOption "Enables nix-config";

      useNixPackageManagerConfig = mkOption {
        type = bool;
        description = "Whether to use custom Nix package manager settings";
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    sops = {
      secrets.github_token = {
        sopsFile = "${self}/secrets/home/${username}/secrets.yaml";
      };
      templates.nix-github = {
        content = ''
          access-tokens = github.com=${config.sops.placeholder.github_token}
        '';
        mode = "0444";
      };
    };

    # Nixpkgs config
    nixpkgs.config.allowUnfree = true;

    # Nix package manager settings
    nix =
      {
        registry.s.flake = inputs.self;

        extraOptions = ''
          !include ${config.sops.templates.nix-github.path}
        '';

        settings = {
          eval-cores = "0";
          lazy-trees = true;
          connect-timeout = 30;
          warn-dirty = false;
          auto-optimise-store = false;
          builders-use-substitutes = true;

          allowed-users = ["@wheel"];

          trusted-users = [username];

          substituters = mkForce [
            "http://127.0.0.1:${toString config.module.services.ncro.port}"
          ];
        };
      }
      // optionalAttrs (options.nix ? optimise) {
        optimise = {
          automatic = true;
          dates = ["weekly"];
          persistent = true;
        };
      };
  };
}
