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
        "cryptd"
      ];
      kernelModules = [ ];
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
    ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs.linuxPackages_cachyos;
  };
}
