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
      settings = {
        global.excludes = [
          "LICENSE"
          ".gitattributes"

          "*.png"
          "*.svg"
          "*.bp"
          "*.conf"
          "*.zsh"
          "**/*rc"
          "**/.gitkeep"

          "secrets/**"
        ];
      };

      programs = {
        deadnix.enable = true;
        nixfmt.enable = true;
        statix.enable = true;
        terraform.enable = true;
        shellcheck.enable = true;
        stylua.enable = true;
        yamlfmt.enable = true;
      };
    };
  };
}
