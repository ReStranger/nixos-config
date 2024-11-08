{ homeModules
, lib
, ...
}:

let
  homeThemesCattpucinMochaMauvePath = "${homeModules}/themes/cattpucin-mocha-mauve";
in {
  # Read all directories from homeModules
  imports = builtins.filter (module: lib.pathIsDirectory module) (
    map (module: "${homeThemesCattpucinMochaMauvePath}/${module}") (builtins.attrNames (builtins.readDir homeThemesCattpucinMochaMauvePath))
  );
}
