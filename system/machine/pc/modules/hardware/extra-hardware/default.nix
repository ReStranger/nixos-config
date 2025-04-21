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
  powerManagement.cpuFreqGovernor = "performance";
}
