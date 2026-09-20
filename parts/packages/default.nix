{
  self,
  localPackages,
  ...
}: {
  perSystem = {pkgs, ...}: let
    selfPkgsUnwrapped = localPackages {
      inherit (pkgs) lib callPackage;
      directory = "${self}/pkgs";
    };
  in {
    packages = selfPkgsUnwrapped;
  };
}
