{
  inputs,
  ...
}:

{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem = _: {
    # For nix fmt
    treefmt.config = {
      projectRootFile = "flake.nix";

      programs = {
        deadnix.enable = true;
        nixfmt.enable = true;
        statix.enable = true;
        terraform.enable = true;
      };
    };
  };
}
