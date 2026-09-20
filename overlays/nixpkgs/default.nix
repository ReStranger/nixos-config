{
  self,
  inputs,
  localPackages,
  ...
}: let
  baseSettings = {
    config = {
      allowBroken = false;
    };
  };

  permittedInsecurePackages = [];
  unfreeSettings =
    baseSettings
    // {
      config =
        baseSettings.config
        // {
          inherit permittedInsecurePackages;
          allowUnfree = true;
        };
    };
in {
  nixpkgs.overlays = [
    (
      final: prev: let
        selfPkgsUnwrapped = localPackages {
          inherit (prev) lib;
          inherit (final) callPackage;
          directory = "${self}/pkgs";
        };
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
        }
    )
  ];
}
