{
  self,
  inputs,
  lib,
  config,
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
    nix = {
      registry.s.flake = inputs.self;

      extraOptions = ''
        !include ${config.sops.templates.nix-github.path}
      '';

      settings = {
        eval-cores = "0";
        lazy-trees = true;
        connect-timeout = 5;
        warn-dirty = false;
        auto-optimise-store = false;
        builders-use-substitutes = true;

        allowed-users = [ "@wheel" ];

        trusted-users = [ username ];

        substituters = [
          "https://cache.nixos.org"
          "https://install.determinate.systems"
          "https://re-cache.cachix.org"
          "https://attic.xuyh0120.win/lantian"
          "https://hyprland.cachix.org"
          "https://wezterm.cachix.org"
          "https://anyrun.cachix.org"
        ];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "re-cache.cachix.org-1:zIzN9Bp2Lwpt5qMc5XReiFsgSx6G4+wZMy9UHCDJ4X4="
          "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
          "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
          "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        ];
      };
    };
  };
}
