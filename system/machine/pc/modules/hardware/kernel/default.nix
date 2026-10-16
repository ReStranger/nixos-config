{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkMerge mkAfter;
in {
  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
        "cryptd"
      ];
      kernelModules = [];
    };
    kernelModules = [
      "amdgpu"
      "kvm-amd"
    ];
    kernelParams = [
      mkMerge
      [
        "mitigations=off"
        "split_lock_detect=off"
        "pci=pcie_bus_perf"
        "threadirqs"
      ]
      (mkAfter [
        "page_poison=0"
        "init_on_alloc=0"
      ])
    ];
    supportedFilesystems = ["ntfs"];
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
  };
}
