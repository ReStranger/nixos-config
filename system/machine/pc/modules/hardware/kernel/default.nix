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
      "page_alloc.shuffle=1"
      "split_lock_detect=off"
      "pci=pcie_bus_perf"
      "threadirqs"
      "noibrs"
      "tsx_async_abort=off"
      "rootfstype=btrfs"
      "selinux=0"
      "raid=noautodetect"
      "preempt=none"
      "hpet=disable"
      "zswap.enabled=0"
      "root=/dev/mapper/nixos-root"
      "cryptdevice=/dev/nvme0n1p2:luks_lvm"
    ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs.linuxPackages_cachyos;
  };
}
