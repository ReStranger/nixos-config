{
  lib
  , config
  , ...
}:
with lib;
let
  cfg = config.module.sound;
in {
  options.module.sound = {
    enable = mkEnableOption "Enable pipewire as backend sound server";
    rtkit = mkOption {
      type = types.bool;
        default = true;
        description = ''
          Enable rtkit support for pipewire
        '';
    };
    alsa = mkOption {
      type = types.bool;
        default = true;
        description = ''
          Enable alsa support for pipewire
        '';
    };
    pulse = mkOption {
      type = types.bool;
        default = true;
        description = ''
          Enable pulse support for pipewire
        '';
    };
    clock-rate = mkOption {
      type = types.enum [ 44100 48000 88200 96000 ];
        default = 96000;
        description = ''
          Select default clock rate for pipewire device
        '';
    };
  };
  config = mkIf cfg.enable {
    security.rtkit.enable = cfg.rtkit;
    services.pipewire = {
      enable = true;
      alsa.enable = cfg.alsa;
      alsa.support32Bit = cfg.alsa;
      pulse.enable = cfg.pulse;
      extraConfig.pipewire = {
        "context.properties" = {
          "default.clock.rate" = cfg.clock-rate;
          "default.clock.allowed-rates" = [ 44100 48000 88200 96000 ];
          "default.clock.min-quantum" = 2048;
          "default.clock.quantum" = 4096;
          "default.clock.max-quantum" = 8192;
        };
      };
    };
  };
}
