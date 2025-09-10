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
}
