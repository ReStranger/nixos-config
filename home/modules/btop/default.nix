{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.module.btop;
in
{
  options.module.btop = {
    enable = mkEnableOption "Enable btop module";
  };

  config = mkIf cfg.enable {
    programs.btop = {
      enable = true;
      settings = {
        theme_background = false;
        truecolor = true;
        force_tty = false;
        vim_keys = true;
        rounded_corners = true;
        update_ms = 300;
      };
    };
  };
}
