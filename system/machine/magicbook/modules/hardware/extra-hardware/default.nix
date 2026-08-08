{
  lib,
  pkgs,
  config,
  ...
}: {
  # Extra drivers settings
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

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

  systemd.services = {
    ath11k-rmmod-before-sleep = {
      description = "Unload ath11k_pci before sleep";
      before = ["sleep.target"];
      wantedBy = ["sleep.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.kmod}/bin/rmmod ath11k_pci";
      };
    };
    ath11k-modprobe-after-suspend = {
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
  };

  environment.systemPackages = with pkgs; [powertop];
}
