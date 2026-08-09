{
  lib,
  machineModulesPath,
  ...
}: let
  inherit (lib) pathIsDirectory;
in {
  imports = builtins.filter (module: pathIsDirectory module) (
    map (module: "${machineModulesPath}/${module}") (
      builtins.attrNames (builtins.readDir machineModulesPath)
    )
  );
}
