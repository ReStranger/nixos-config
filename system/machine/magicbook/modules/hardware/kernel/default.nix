{ pkgs
  , ...
}:
{
  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" ];
      kernelModules = [ "amdgpu" ];
    };
    kernelModules = [ "amdgpu" "kvm-amd" ];
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
      "vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166" 
      "vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173" 
      "vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200"
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
