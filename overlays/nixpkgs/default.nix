{ self, ... }:
final: prev:
builtins.mapAttrs (_: value: value.default) (prev.lib.packagesFromDirectoryRecursive {
  inherit (final) callPackage;
  directory = "${self}/pkgs";
})
