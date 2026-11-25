{ self, ... }: {
  perSystem = { pkgs, ... }:
    let
      pkgs' = pkgs.extend self.overlays.default;
      packageDirs = pkgs'.lib.filterAttrs (_: type: type == "directory") (builtins.readDir "${self}/pkgs");
    in
    {
      packages = pkgs'.lib.genAttrs
        (builtins.attrNames packageDirs)
        (name: pkgs'.${name});
    };
}
