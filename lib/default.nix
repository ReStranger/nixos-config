{
  self
  , inputs
  , ...
}: let
  homeConfiguration   = "${self}/home";
  systemConfiguration = "${self}/system";

  homeModules         = "${homeConfiguration}/modules";
  systemModules       = "${systemConfiguration}/modules";
  commonModules       = "${self}/modules";

  mkHost = machineDir:
    { username ? "user"
    , stateVersion ? "24.05"
    , platform ? "x86_64-linux" 
    , hostname ? machineDir
    , isWorkstation ? false
    , wm ? null
    }:
    let
      machineConfigurationPath      = "${self}/system/machine/${machineDir}";
      machineConfigurationPathExist = builtins.pathExists machineConfigurationPath;
      machineModulesPath            = "${self}/system/machine/${machineDir}/modules";
      machineModulesPathExist       = builtins.pathExists machineModulesPath;
      hyprlandEnable = wm == "hyprland";
      deEnable       = hyprlandEnable;
    in inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          self
          hostname
          username
          stateVersion
          platform
          machineDir
          isWorkstation
          wm
          homeModules
          commonModules
          systemModules
          machineConfigurationPath
          machineConfigurationPathExist
          machineModulesPath
          machineModulesPathExist
          hyprlandEnable
          deEnable;
      };
      modules = [
        "${systemConfiguration}"
        "${homeConfiguration}"
      ];
    };
  mkHostDarwin = hostname:
    { username ? "user"
    , stateVersion ? 6
    , platform ? "aarch64-darwin" 
    }:
    inputs.darwin.lib.darwinSystem {
      specialArgs = {
        inherit
          inputs
          self
          hostname
          username
          platform
          stateVersion
          systemModules
          commonModules;
      };

      modules = [
        "${systemConfiguration}"
        "${homeConfiguration}"
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
          stateVersion
          systemModules
          commonModules;
      };

      modules = [
        "${systemConfiguration}"
        "${homeConfiguration}"
      ];
    };
in {
  forAllSystems = inputs.nixpkgs.lib.systems.flakeExposed;

  genNixos  = builtins.mapAttrs mkHost;
  genDarwin = builtins.mapAttrs mkHostDarwin;
  genAndroid = builtins.mapAttrs mkHostAndroid;
}
