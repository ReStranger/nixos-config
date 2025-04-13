{
  description = "ReStranger's nix system configuration";

  outputs =
    { self
    , flake-parts
    , ...
    }@inputs:
    let
      hosts = import ./hosts.nix;
      libx = import ./lib { inherit self inputs; };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = libx.forAllSystems;

      imports = [
        ./parts
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

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
    };

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
    };

    nix-topology = {
      url = "github:oddlama/nix-topology";
    };

    impermanence = {
      url = "github:/nix-community/impermanence";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
    };

    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    matugen.url = "github:InioX/Matugen?rev=0bd628f263b1d97f238849315f2ce3ab4439784e";

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland";
    };

    xdghypr = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ayugram-desktop = {
      type = "git";
      submodules = true;
      url = "https://github.com/ndfined-crp/ayugram-desktop/";
    };

    wezterm.url = "github:wez/wezterm?dir=nix";

    minimal-tmux = {
      url = "github:niksingh710/minimal-tmux-status";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
}
