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
      "usbcore.autosuspend=2"
      "pcie_aspm.policy=powersupersave"
      "amdgpu.aspm=1"
      "amdgpu.runpm=-2"
      "nvme_core.default_ps_max_latency_us=15000"
      "nvme_core.apst_primary_latency_tol_us=15000"
      "nvme_core.apst_secondary_latency_tol_us=15000"
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
