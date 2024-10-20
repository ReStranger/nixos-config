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
    { username ? "restranger"
    , stateVersion ? "24.05"
    , platform ? "x86_64-linux" 
    , hostname ? machineDir
    , isWorkstation ? false
    , de ? null
    }:
    let
      machineConfigurationPath      = "${self}/system/machine/${machineDir}";
      machineConfigurationPathExist = builtins.pathExists machineConfigurationPath;
      machineModulesPath            = "${self}/system/machine/${machineDir}/modules";
      machineModulesPathExist       = builtins.pathExists machineModulesPath;
      hyprlandEnable = de == "hyprland";
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
          de
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


in {
  forAllSystems = inputs.nixpkgs.lib.systems.flakeExposed;

  genNixos  = builtins.mapAttrs mkHost;
}
