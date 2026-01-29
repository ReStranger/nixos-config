{
  self,
  inputs,
  ...
}:
let

  defaultStateVersion = "25.11";

  constructors = [
    "${self}/home"
    "${self}/system"
  ];
  allDirs =
    dirName:
    builtins.filter (
      module: ((builtins.pathExists module) && ((builtins.readFileType module) == "directory"))
    ) (map (module: "${dirName}/${module}") (builtins.attrNames (builtins.readDir dirName)));

  mkHost =
    machineDir:
    {
      username ? "user",
      stateVersion ? defaultStateVersion,
      hmStateVersion ? stateVersion,
      platform ? "x86_64-linux",
      hostname ? machineDir,
      isWorkstation ? false,
      isLaptop ? false,
      wm ? null,
      theme ? "catppuccin-mocha",
      hostType ? "nixos",
    }:
    let
      hyprlandEnable = wm == "hyprland";
      deEnable = hyprlandEnable;
      nixosSystem =
        if stateVersion == defaultStateVersion then
          inputs.stable.lib.nixosSystem
        else
          inputs.nixpkgs.lib.nixosSystem;
    in
    nixosSystem {
      specialArgs = {
        inherit
          inputs
          self
          allDirs
          hostname
          username
          stateVersion
          hmStateVersion
          platform
          machineDir
          isWorkstation
          isLaptop
          wm
          theme
          hyprlandEnable
          deEnable
          hostType
          ;
      };
      modules = [
        inputs.home-manager.nixosModules.home-manager
        inputs.stylix.nixosModules.stylix
        inputs.sops-nix.nixosModules.sops
        # inputs.nur.modules.nixos.default
      ]
      ++ constructors;
    };
  mkHostDarwin =
    machineDir:
    {
      username ? "user",
      stateVersion ? 6,
      hmStateVersion ? defaultStateVersion,
      hostname ? machineDir,
      platform ? "aarch64-darwin",
      isWorkstation ? false,
      isLaptop ? true,
      wm ? null,
      theme ? "catppuccin-mocha",
      hostType ? "darwin",
    }:
    let
      hyprlandEnable = wm == "hyprland";
      deEnable = hyprlandEnable;
    in
    inputs.darwin.lib.darwinSystem {
      specialArgs = {
        inherit
          inputs
          self
          allDirs
          hostname
          username
          platform
          isWorkstation
          isLaptop
          machineDir
          stateVersion
          hmStateVersion
          wm
          theme
          hyprlandEnable
          deEnable
          hostType
          ;
      };

      modules = [
        inputs.home-manager.darwinModules.home-manager
        inputs.stylix.darwinModules.stylix
      ]
      ++ constructors;
    };
  mkHostAndroid =
    hostname:
    {
      username ? "user",
      # , stateVersion ? 6
      platform ? "aarch64",
    }:
    inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      specialArgs = {
        inherit
          inputs
          self
          allDirs
          hostname
          username
          platform
          ;
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
