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
      kernelModules = [ "amdgpu" ];

    };
    kernelModules = [ "kvm-amd" ];
    kernelParams = [
      "quiet"
      "splash"
      "zswap.enabled=0"
      "nmi_watchdog=0"
      "usbcore.autosuspend=5"
      "vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166" 
      "vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173" 
      "vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200"
    ];
    kernel.sysctl = {
      "vm.laptop_mode" = 5;
    };
    extraModulePackages = [ ];
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;
  };
}
