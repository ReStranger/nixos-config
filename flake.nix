{
  description = "ReStranger's nix system configuration";

  outputs = {
        self
      , nixpkgs
      , nixpkgs-stable
      , flake-parts
      , home-manager
      , ayugram-desktop
      , ...
    }@inputs:
    let
      hosts = import ./hosts.nix;
      libx = import ./lib.nix { inherit self inputs; };
    in flake-parts.lib.mkFlake { inherit inputs; } {
      systems = libx.forAllSystems;

      import = [
        # ./parts
        # ./docs
      ];
      flake = {
        nixosConfigurations = libx.genNixos hosts.nixos;
      };
  };

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nix-topology = {
      url = "github:oddlama/nix-topology";
    };


    ags.url = "github:Aylur/ags";

    ayugram-desktop.url = "github:kaeeraa/ayugram-desktop/release?submodules=1";

    minimal-tmux = {
      url = "github:niksingh710/minimal-tmux-status";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
