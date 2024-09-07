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
      };
    };
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" ];
      kernelModules = [ ];

    };
    kernelModules = [ "kvm-amd" "amdgpu" ];
    kernelParams = [
      "quiet"
      "splash"
      "zswap.enabled=0"
    ];
    extraModulePackages = [ ];
  };
}
