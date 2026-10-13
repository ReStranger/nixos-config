{pkgs, ...}: {
  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
        "cryptd"
      ];
    };
    resumeDevice = "/dev/mapper/vg-nixos";
    kernelModules = [
      "amdgpu"
      "kvm-amd"
    ];
    kernelParams = [
      "mitigations=off"
      "split_lock_detect=off"
      "threadirqs"
      "usbcore.autosuspend=5"
      "resume_offset=8972000"
    ];
    kernel.sysctl = {
      "vm.laptop_mode" = 5;
      "net.ipv4.ip_default_ttl" = 65;
      "vm.dirty_writeback_centisecs" = 1500;
    };
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
  };
}
