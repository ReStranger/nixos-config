{ homeModules
, lib
, ...
}:

let
  homeThemesCattpucinMochaMauvePath = "${homeModules}/themes/catppuccin-mocha-mauve";
in
{
  # Read all directories from homeModules
  imports = builtins.filter (module: lib.pathIsDirectory module) (
    map (module: "${homeThemesCattpucinMochaMauvePath}/${module}") (builtins.attrNames (builtins.readDir homeThemesCattpucinMochaMauvePath))
  );
}
