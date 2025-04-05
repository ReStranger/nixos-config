{ self
, inputs
, ...
}:
let

  defaultStateVersion = "24.11";

  mkHost = machineDir:
    { username ? "user"
    , stateVersion ? defaultStateVersion
    , hmStateVersion ? stateVersion
    , platform ? "x86_64-linux"
    , hostname ? machineDir
    , isWorkstation ? false
    , wm ? null
    }:
    let
      hyprlandEnable = wm == "hyprland";
      deEnable = hyprlandEnable;
      nixosSystem =
          if stateVersion == defaultStateVersion
          then inputs.stable.lib.nixosSystem
          else inputs.nixpkgs.lib.nixosSystem;
    in
    nixosSystem {
      specialArgs = {
        inherit
          inputs
          self
          hostname
          username
          stateVersion
          hmStateVersion
          platform
          machineDir
          isWorkstation
          wm
          hyprlandEnable
          deEnable;
      };
      modules = [
        inputs.home-manager.nixosModules.home-manager
        inputs.stylix.nixosModules.stylix
        inputs.chaotic.nixosModules.default
        inputs.nur.modules.nixos.default
        "${self}/system/nixos/modules"
        "${self}/system"
        "${self}/home"
      ];
    };
  mkHostDarwin = machineDir:
    { username ? "user"
    , stateVersion ? 6
    , hmStateVersion ? defaultStateVersion
    , hostname ? machineDir
    , platform ? "aarch64-darwin"
    , isWorkstation ? false
    , wm ? null
    }:
    let
      hyprlandEnable = wm == "hyprland";
      deEnable       = hyprlandEnable;
    in inputs.darwin.lib.darwinSystem {
      specialArgs = {
        inherit
          inputs
          self
          hostname
          username
          platform
          isWorkstation
          machineDir
          stateVersion
          hmStateVersion
          wm
          hyprlandEnable
          deEnable;
      };

      modules = [
        inputs.home-manager.darwinModules.home-manager
        inputs.stylix.darwinModules.stylix
        "${self}/system/darwin/modules"
        "${self}/system"
        "${self}/home"
      ];
    };
  mkHostAndroid = hostname:
    { username ? "user"
      # , stateVersion ? 6
    , platform ? "aarch64"
    }:
    inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      specialArgs = {
        inherit
          inputs
          self
          hostname
          username
          platform
          # stateVersion
      };

      modules = [
      ];
    };
in
{
  forAllSystems = inputs.nixpkgs.lib.systems.flakeExposed;

  genNixos = builtins.mapAttrs mkHost;
  genDarwin = builtins.mapAttrs mkHostDarwin;
  genAndroid = builtins.mapAttrs mkHostAndroid;
}
