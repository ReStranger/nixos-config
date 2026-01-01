{
  config,
  lib,
  ...
}:

let
  cfg = config.module.mangohud;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.mangohud = {
    enable = mkEnableOption "Enable mangohud module";
  };

  config = mkIf cfg.enable {
    programs.mangohud = {
      enable = true;
      settings = {
        gpu_stats = true;
        gpu_temp = true;
        cpu_stats = true;
        cpu_temp = true;
        fps = true;
        frametime = true;
        throttling_status = true;
        frame_timing = true;
        text_outline = true;
        alpha = 1.0;
        background_alpha = 1.0;
        font_scale = 1.33333;
        no_display = true;
      };
    };
  };
}
