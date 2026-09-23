{config, ...}: {
  nixpkgs.overlays = [
    (final: prev: {
      nurl = prev.nurl.override {nix = config.nix.package;};
      nix-init = prev.nix-init.override {
        nix = config.nix.package;
        inherit (final) nurl;
      };
      nixpkgs-review = prev.nixpkgs-review.override {nix = config.nix.package;};
      nix-update = prev.nix-update.override {
        nix = config.nix.package;
        inherit (final) nixpkgs-review;
      };
      nix-direnv = prev.nix-direnv.override {nix = config.nix.package;};
      nixos-anywhere = prev.nixos-anywhere.override {nix = config.nix.package;};
      nixos-rebuild-ng = prev.nixos-rebuild-ng.override {nix = config.nix.package;};
      colmena = prev.colmena.override {
        nix = config.nix.package;
        inherit (prev) nix-eval-jobs;
      };
    })
  ];
}
