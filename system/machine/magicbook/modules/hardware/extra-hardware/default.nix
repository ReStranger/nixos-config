{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkDefault;
in {
  # Extra drivers settings
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;

    firmware = with pkgs; [
      linux-firmware
    ];
  };

  services.udev = {
    extraRules = ''
      ACTION=="add|change", SUBSYSTEM=="pci", TEST=="power/control", ATTR{power/control}="auto"
    '';
    extraHwdb = ''
      battery:*:*:dmi:*
       CHARGE_LIMIT=75,95
    '';
  };

  environment.systemPackages = with pkgs; [powertop];
}
