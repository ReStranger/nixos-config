{
  config,
  lib,
  ...
}:

let
  cfg = config.module.ccache;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.ccache = {
    enable = mkEnableOption "Enable ccache module";
  };

  config = mkIf cfg.enable {
    programs.ccache = {
      enable = true;
      owner = "$(whoami)";
      group = "users";
      cacheDir = "/mnt/ccache";
    };
  };
}
