{ pkgs, ... }:
{
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
      };
    };
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-amd" ];
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
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia_drm.modeset=1"
      "nvidia_drm.fbdev=1"
    ];
    extraModulePackages = [
    ];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  };
  powerManagement.cpuFreqGovernor = "performance";
}
