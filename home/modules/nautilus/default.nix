{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.module.nautilus;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.nautilus = {
    enable = mkEnableOption "Enable nautilus module";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        nautilus
        nautilus-python
      ];
      sessionVariables = {
        NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
      };
    };

    xdg.dataFile."nautilus/scripts".source = ./scripts;

    dconf = {
      settings = {
        "org/gnome/nautilus/icon-view".default-zoom-level = "small-plus";
        "com/github/stunkymonkey/nautilus-open-any-terminal".terminal = "wezterm";
      };
    };
  };
}
