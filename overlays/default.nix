args@{ self, inputs, ... }:
let
  inherit (inputs.nixpkgs.lib) filterAttrs composeManyExtensions;

  overlays = builtins.mapAttrs
    (name: _: import ./${name} args)
    (filterAttrs (name: type: type == "directory" && builtins.pathExists ./${name}/default.nix) (builtins.readDir ./.));
in
overlays // {
  default = composeManyExtensions (builtins.attrValues overlays);
}
