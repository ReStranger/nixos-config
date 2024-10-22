{ inputs
, lib
, config
, pkgs
, ...
}:

with lib;

let
  cfg = config.module.nix-config;
in {
  options = {
    module.nix-config = {
      enable = mkEnableOption "Enables nix-config";

      useNixPackageManagerConfig = mkOption {
        type = types.bool;
        description = "Whether to use custom Nix package manager settings";
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    # Nixpkgs config
    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePerdicate = (_: true);
    };

    # Nix package manager settings
    nix = {
      package = pkgs.nixVersions.latest;
      registry.s.flake = inputs.self;

      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;

        substituters = [
          "https://cache.garnix.io"
        ];

        trusted-public-keys = [
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        ];
      };
      # gc = {
      #   automatic = true;
      #   dates = "weekly";
      #   options = "--delete-older-than 7d";
      # };
    };
  };
}
