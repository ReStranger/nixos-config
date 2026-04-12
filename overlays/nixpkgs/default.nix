{
  self,
  inputs,
  config,
  ...
}:
let
  baseSettings = {
    config = {
      allowBroken = false;
    };
  };

  permittedInsecurePackages = [ ];
  unfreeSettings = baseSettings // {
    config = baseSettings.config // {
      inherit permittedInsecurePackages;
      allowUnfree = true;
    };
  };
in
{
  nixpkgs.overlays = [
    (
      final: prev:
      let
        selfPkgs = prev.lib.packagesFromDirectoryRecursive {
          inherit (final) callPackage;
          directory = "${self}/pkgs";
        };

        selfPkgsUnwrapped = builtins.mapAttrs (
          _name: value: if (builtins.isAttrs value && value ? default) then value.default else value
        ) selfPkgs;
      in
      selfPkgsUnwrapped
      // {
        stable = import inputs.stable {
          inherit (final.stdenv.hostPlatform) system;
          inherit (baseSettings) config;
        };
        stable-unfree = import inputs.stable {
          inherit (final.stdenv.hostPlatform) system;
          inherit (unfreeSettings) config;
        };

        unstable = import inputs.unstable {
          inherit (final.stdenv.hostPlatform) system;
          inherit (baseSettings) config;
        };
        unstable-unfree = import inputs.unstable {
          inherit (final.stdenv.hostPlatform) system;
          inherit (unfreeSettings) config;
        };

        master = import inputs.master {
          inherit (final.stdenv.hostPlatform) system;
          inherit (baseSettings) config;
        };
        master-unfree = import inputs.master {
          inherit (final.stdenv.hostPlatform) system;
          inherit (unfreeSettings) config;
        };
        nix-init = prev.nix-init.override { nix = config.nix.package; };
        nixpkgs-review = prev.nixpkgs-review.override { nix = config.nix.package; };
        nix-update = prev.nix-update.override { nix = config.nix.package; };
        nix-direnv = prev.nix-direnv.override { nix = config.nix.package; };
      }
    )
  ];

}
