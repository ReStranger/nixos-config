{ inputs, ... }:
final: prev:
let
  system = final.stdenv.hostPlatform.system;
  determinateNix = inputs.determinate.inputs.nix.packages.${system}.default or prev.nix;
  withNix = pkg: overrides: pkg.override ({ nix = determinateNix; } // overrides);
in
{
  nurl = withNix prev.nurl { };
  nix-init = withNix prev.nix-init { inherit (final) nurl; };
  nixpkgs-review = withNix prev.nixpkgs-review { };
  nix-update = withNix (inputs.master.legacyPackages.${system}.nix-update or prev.nix-update) {
    inherit (final) nixpkgs-review;
  };
  nix-direnv = withNix prev.nix-direnv { };
  nixos-anywhere = withNix prev.nixos-anywhere { };
  nixos-rebuild-ng = withNix prev.nixos-rebuild-ng { };
}
