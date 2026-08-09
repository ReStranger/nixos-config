{lib, ...}: let
  inherit (lib) pathIsDirectory;
in {
  imports = builtins.filter (module: pathIsDirectory module) (
    map (module: toString ./. + "/${module}") (
      builtins.attrNames (builtins.readDir (toString ./.))
    )
  );
}
