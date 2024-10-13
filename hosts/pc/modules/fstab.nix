{
  fileSystems."/" =
    {
      device = "/dev/nvme0n1p2";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/nvme0n1p2";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/.snapshots" =
    {
      device = "/dev/nvme0n1p2";
      fsType = "btrfs";
      options = [ "subvol=@.snapshots" ];
    };

  fileSystems."/boot/efi" =
    {
      device = "/dev/nvme0n1p1";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  fileSystems."/mnt/sda1" =
    {
      device = "/dev/sda1";
      fsType = "btrfs";
      options = [ "x-gvfs-show" "x-gvfs-name=HDD%201" ];
    };
  fileSystems."/mnt/win" =
    {
      device = "/dev/nvme0n1p5";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" "x-gvfs-show" "x-gvfs-name=Win11" "x-gvfs-icon=windows" "x-gvfs-symbolic-icon=windows" ];
    };
  fileSystems."/mnt/win_hdd" =
    {
      device = "/dev/sda2";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" "x-gvfs-show" "x-gvfs-name=WinHDD" ];
    };
  swapDevices = [
    {
      device = "/swap/swapfile";
      priority = 1;
    }
  ];
}
