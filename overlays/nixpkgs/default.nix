{
  self,
  localPackages,
  ...
}: {
  nixpkgs.overlays = [
    (
      final: prev:
        localPackages {
          inherit (prev) lib;
          inherit (final) callPackage;
          directory = "${self}/pkgs";
        }
    )
  ];
}
