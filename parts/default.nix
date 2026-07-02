{lib, ...}: {
  imports = builtins.filter (module: lib.pathIsDirectory module) (
    map (module: toString ./. + "/${module}") (
      builtins.attrNames (builtins.readDir (toString ./.))
    )
  );
}
