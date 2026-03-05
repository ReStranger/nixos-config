{
  lib,
  pkgs,
  config,
  ...
}:
{
  # Extra drivers settings
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    firmware = with pkgs; [
      linux-firmware
    ];

  };
  #   services.udev.extraRules = ''
  # ACTION=="add", SUBSYSTEM=="net", KERNEL=="wl*", RUN+="/usr/bin/iw dev $name set power_save on"
  # SUBSYSTEM=="pci", ATTR{power/control}="auto"
  # ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"
  #   '';

  systemd.services.ath11k-rmmod-before-sleep = {
    description = "Unload ath11k_pci before sleep";
    before = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kmod}/bin/rmmod ath11k_pci";
    };
  };

  systemd.services.ath11k-modprobe-after-suspend = {
    description = "Load ath11k_pci after suspend.target";
    after = [
      "suspend.target"
      "suspend-then-hibernate.target"
      "hibernate.target"
      "hybrid-sleep.target"
    ];
    wantedBy = [
      "suspend.target"
      "suspend-then-hibernate.target"
      "hibernate.target"
      "hybrid-sleep.target"
    ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kmod}/bin/modprobe ath11k_pci";
    };
  };
}
