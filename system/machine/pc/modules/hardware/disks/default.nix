{
  username,
  ...
}:
{

  boot.initrd.luks.devices = {
    cryptroot.device = "/dev/nvme0n1p5";
    cryptstorage.device = "/dev/disk/by-id/wwn-0x50014ee2153e7621-part1";
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
      device = "/dev/nvme0n1p6";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
    "/mnt/sda1" = {
      device = "/dev/disk/by-label/STORAGE";
      fsType = "btrfs";
      options = [
        "defaults"
        "discard=async"
        "space_cache=v2"
        "x-gvfs-show"
        "x-gvfs-name=HDD%201"
        "autodefrag"
      ];
    };
    "/mnt/win" = {
      device = "/dev/nvme0n1p3";
      fsType = "ntfs-3g";
      options = [
        "rw"
        "uid=1000"
        "x-gvfs-show"
        "x-gvfs-name=Win10"
        "x-gvfs-icon=windows"
        "x-gvfs-symbolic-icon=windows"
      ];
    };
    "/mnt/win_hdd" = {
      device = "/dev/sda2";
      fsType = "ntfs-3g";
      options = [
        "rw"
        "uid=1000"
        "x-gvfs-show"
        "x-gvfs-name=WinHDD"
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
