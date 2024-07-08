{ pkgs, ...}:
{
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.kernelPackages = pkgs.linuxPackages_zen;
}
