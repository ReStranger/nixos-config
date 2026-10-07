{inputs, ...}: {
  nixpkgs.overlays = [
    (
      final: _prev: let
        pinnedPkgs = import inputs.davinci-nixpkgs {
          system = final.stdenv.hostPlatform.system;
          config.allowUnfree = true;
        };
      in {
        davinci-resolve_20 = pinnedPkgs.callPackage ./package.nix {};
      }
    )
  ];
}
