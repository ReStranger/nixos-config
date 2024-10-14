{
  description = "ReStranger's nix system configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "github:Aylur/ags";
    ayugram-desktop.url = "github:kaeeraa/ayugram-desktop/release?submodules=1";
    minimal-tmux = {
      url = "github:niksingh710/minimal-tmux-status";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ayugram-desktop, ... }@inputs:
    let
      x86_64 = "x86_64-linux";
      aarch64 = "aarch64-linux";
    in
    {
      nixosConfigurations = {
        pc = nixpkgs.lib.nixosSystem {
          system = { inherit x86_64; };
          modules = [ 
            ./hosts/pc
            home-manager.nixosModules.home-manager {
              home-manager = {
                backupFileExtension = "backup";
                useUserPackages = true;
                users.restranger = import ./home/restranger;
                extraSpecialArgs = { inherit inputs; };
              };
            }
          ];
        };

        magicbook = nixpkgs.lib.nixosSystem {
          system = { inherit x86_64; };
          modules = [ 
            ./hosts/magicbook 
            home-manager.nixosModules.home-manager {
              home-manager = {
                backupFileExtension = "backup";
                useUserPackages = true;
                users.restranger = import ./home/restranger;
                extraSpecialArgs = { inherit inputs; };
              };
            }
          ];
        };
      };
    };
}
