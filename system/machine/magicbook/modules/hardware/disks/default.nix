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
        "defaults"
        "subvol=@"
        "discard=async"
        "space_cache=v2"
        "ssd"
        "ssd_spread"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      neededForBoot = true;
      options = [
        "defaults"
        "subvol=@home"
        "discard=async"
        "space_cache=v2"
        "ssd"
        "ssd_spread"
      ];
    };
    "/var/log" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "defaults"
        "subvol=@log"
        "noatime"
        "discard=async"
        "space_cache=v2"
        "ssd"
        "ssd_spread"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "defaults"
        "subvol=@nix"
        "noatime"
        "discard=async"
        "space_cache=v2"
        "ssd"
        "ssd_spread"
      ];
    };

    "/.snapshots" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "defaults"
        "subvol=@.snapshots"
        "discard=async"
        "space_cache=v2"
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
