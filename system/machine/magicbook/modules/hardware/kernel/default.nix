{
  pkgs,
  ...
}:
{
  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ "amdgpu" ];
    };
    kernelModules = [
      "amdgpu"
      "kvm-amd"
    ];
    kernelParams = [
      "loglevel=3"
      "quiet"
      "splash"
      "mitigations=off"
      "nowatchdog"
      "split_lock_detect=off"
      "pci=pcie_bus_perf"
      "threadirqs"
      "noibrs"
      "rootfstype=btrfs"
      "selinux=0"
      "raid=noautodetect"
      "preempt=none"
      "hpet=disable"
      "nmi_watchdog=0"
      "usbcore.autosuspend=5"
    ];
    kernel.sysctl = {
      "vm.laptop_mode" = 5;
      "net.ipv4.ip_default_ttl" = 65;
    };
    extraModulePackages = [ ];
    kernelPackages = pkgs.linuxPackages_latest;
  };
}
