{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire = {
      "context.properties" = {
        "default.clock.rate" = 96000;
        "default.clock.allowed-rates" = [ 44100 48000 88200 96000 ];
        "default.clock.min-quantum" = 2048;
        "default.clock.quantum" = 4096;
        "default.clock.max-quantum" = 8192;
      };
    };
  };
}
