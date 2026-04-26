{ config, ... }:
{

  nixpkgs.overlays = [
    (final: prev: {
      nix-init = prev.nix-init.override { nix = config.nix.package; };
      nixpkgs-review = prev.nixpkgs-review.override { nix = config.nix.package; };
      nix-update = prev.nix-update.override { nix = config.nix.package; };
      nix-direnv = prev.nix-direnv.override { nix = config.nix.package; };
    })
  ];
}
