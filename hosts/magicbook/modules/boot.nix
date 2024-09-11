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
      "quiet"
      "splash"
      "zswap.enabled=0"
      "nmi_watchdog=0"
      "usbcore.autosuspend=5"
    ];
    kernel.sysctl = {
      "vm.laptop_mode" = 5;
    };
    extraModulePackages = [ ];
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;
  };
}
