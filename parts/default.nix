{lib, ...}: let
  inherit (lib) pathIsDirectory;
in {
  imports = builtins.filter pathIsDirectory (
    map (module: toString ./. + "/${module}") (
      builtins.attrNames (builtins.readDir (toString ./.))
    )
  );
}
