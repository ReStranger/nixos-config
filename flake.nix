{
  description = "My system configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "github:Aylur/ags";
    ayugram-desktop.url = "github:kaeeraa/ayugram-desktop/release?submodules=1";

  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ayugram-desktop, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
        system = { inherit system; };
        modules = [ ./hosts/pc ];
      };

      nixosConfigurations.magicbook = nixpkgs.lib.nixosSystem {
        system = { inherit system; };
        modules = [ ./hosts/magicbook ];
      };

      homeConfigurations.restranger = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; };
        modules = [ ./home/restranger ];
        extraSpecialArgs = { inherit inputs; };
      };
    };
}
