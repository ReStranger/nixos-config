{
  inputs,
  lib,
  config,
  pkgs,
  username,
  ...
}:

let
  cfg = config.module.nix-config;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    ;
  inherit (lib.types) bool;
in
{
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
    # Nixpkgs config
    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePerdicate = _: true;
    };

    # Nix package manager settings
    nix = {
      package = pkgs.lix;
      registry.s.flake = inputs.self;

      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          "repl-flake"
        ];
        auto-optimise-store = true;
        builders-use-substitutes = true;

        allowed-users = [ "@wheel" ];

        trusted-users = [
          "root"
          username
        ];

        substituters = [
          "https://cache.garnix.io"
          "https://hyprland.cachix.org"
          "https://nyx.chaotic.cx"
          "https://wezterm.cachix.org"
          "https://anyrun.cachix.org"
        ];

        trusted-public-keys = [
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="

          "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
          "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
          "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        ];
      };
      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      };
    };
  };
}
