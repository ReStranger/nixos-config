{ lib
, config
, ...
}:
let
  cfg = config.module.services.scx-loader;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.services.scx-loader.enable = mkEnableOption "Enable scx-loader";
  config = mkIf cfg.enable {
    services.scx-loader = {
      enable = true;
      config = {
        default_sched = "scx_lavd";
        scheds.scx_lavd = {
          auto_mode = [ "--autopilot" "--pinned-slice-us" "500" ];
          gaming_mode = [ "--performance" "--pinned-slice-us" "500" ];
          lowlatency_mode = [ "--performance" "--pinned-slice-us" "500" ];
          powersave_mode = [ "--powersave" "--pinned-slice-us" "500" ];
          server_mode = [ "--performance" "--slice-min-us" "3000" "--slice-max-us" "10000" "--pinned-slice-us" "3000" ];
        };
      };
    };
  };
}
