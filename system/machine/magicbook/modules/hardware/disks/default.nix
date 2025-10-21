{
  username,
  ...
}:
{
  boot.initrd.luks.devices = {
    cryptroot.device = "/dev/disk/by-id/nvme-KBG50ZNV512G_KIOXIA_935C961QECJX_1-part2";
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvol=@"
        "discard=async"
        "ssd"
        "ssd_spread"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "discard=async"
        "ssd"
        "ssd_spread"
      ];
    };
    "/var/log" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvol=@log"
        "noatime"
        "discard=async"
        "ssd"
        "ssd_spread"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "noatime"
        "discard=async"
        "ssd"
        "ssd_spread"
      ];
    };

    "/.snapshots" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvol=@.snapshots"
        "discard=async"
        "ssd"
        "ssd_spread"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
    "/mnt/ccache" = {
      device = "/home/${username}/.cache/ccache";
      fsType = "none";
      options = [
        "bind"
      ];
    };
  };
  swapDevices = [
    {
      device = "/swap/swapfile";
      priority = 1;
    }
  ];
}
