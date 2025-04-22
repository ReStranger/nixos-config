{
  config,
  lib,
  ...
}:

let
  cfg = config.module.zathura;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.zathura = {
    enable = mkEnableOption "Enable zathura module";
  };

  config = mkIf cfg.enable {
    programs.zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
        recolor = true;
      };
      mappings = {
        "<C-l> feedkeys" = ":blist <Tab>";
        "<C-m> feedkeys" = ":bmark ";
        "<C-u> feedkeys" = ":bdelete ";
        i = "recolor";
      };
    };
  };
}
