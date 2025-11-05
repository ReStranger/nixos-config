{
  username,
  ...
}:
{

  boot.initrd.luks.devices = {
    cryptroot.device = "/dev/disk/by-id/nvme-eui.002538da11b3a04c-part2";
    cryptstorage.device = "/dev/disk/by-id/wwn-0x50014ee2153e7621-part1";
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
      neededForBoot = true;
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
      device = "/dev/nvme0n1p1";
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
        "x-gvfs-show"
        "x-gvfs-name=HDD%201"
        "autodefrag"
      ];
    };
    "/mnt/win" = {
      device = "/dev/nvme0n1p4";
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
    # fileSystems."/mnt/win_hdd" =
    #   {
    #     device = "/dev/sda2";
    #     fsType = "ntfs-3g";
    #     options = [ "rw" "uid=1000" "x-gvfs-show" "x-gvfs-name=WinHDD" ];
    #   };
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
