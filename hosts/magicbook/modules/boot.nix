{ pkgs, ...}:
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
  };
  # kernelPackages = pkgs.linuxPackages_zen;
}
