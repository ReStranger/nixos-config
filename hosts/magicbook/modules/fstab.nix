{
  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/bfda191b-5b77-4a10-a353-8be0599fd3ba";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/bfda191b-5b77-4a10-a353-8be0599fd3ba";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/.snapshots" =
    {
      device = "/dev/disk/by-uuid/bfda191b-5b77-4a10-a353-8be0599fd3ba";
      fsType = "btrfs";
      options = [ "subvol=@.snapshots" ];
    };

  fileSystems."/boot/efi" =
    {
      device = "/dev/nvme0n1p1";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  swapDevices = [ ];

}
