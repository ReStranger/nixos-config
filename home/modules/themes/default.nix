{ homeModules
, lib
, ...
}:

let
  homeThemesPath = "${homeModules}/themes";
in {
  # Read all directories from homeModules
  imports = builtins.filter (module: lib.pathIsDirectory module) (
    map (module: "${homeThemesPath}/${module}") (builtins.attrNames (builtins.readDir homeThemesPath))
  );
}
