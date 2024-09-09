{ pkgs, ... }:
let
  nautilusEnv = pkgs.buildEnv {
    name = "nautilus-env";

    paths = with pkgs; [
      nautilus
      nautilus-python
      nautilus-open-any-terminal
    ];
  };
in

{
  home = {
    packages = [ nautilusEnv ];
    sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${nautilusEnv}/lib/nautilus/extensions-4";
  };

  dconf = {
    enable = true;
    settings."com/github/stunkymonkey/nautilus-open-any-terminal".terminal = "kitty";
  };
}
