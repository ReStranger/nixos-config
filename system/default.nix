{ lib
, inputs
, self
, commonModules
, systemModules
, machineConfigurationPath
, machineConfigurationPathExist
, machineModulesPath
, machineModulesPathExist
, platform ? null
, stateVersion ? null
, ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    # inputs.impermanence.nixosModules.impermanence
    inputs.disko.nixosModules.disko
    inputs.nix-topology.nixosModules.default
    # inputs.nur.nixosModules.nur

    "${commonModules}"
    "${systemModules}"
    "${self}/overlays/nixpkgs"
  ]
  ++ lib.optional machineConfigurationPathExist machineConfigurationPath
  ++ lib.optional machineModulesPathExist machineModulesPath;

  module.nix-config.enable = true;

  # System version
  system = { inherit stateVersion; };
  # HostPlatform
  nixpkgs = {
    overlays = [
    ];

    hostPlatform = platform;
  };
}
