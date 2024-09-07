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
    };
  swapDevices = [ ];
}
