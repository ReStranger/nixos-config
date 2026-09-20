libx: let
  inherit (libx) allDirs localPackages;
in {
  _module.args = {inherit localPackages;};
  imports = allDirs ./.;
}
