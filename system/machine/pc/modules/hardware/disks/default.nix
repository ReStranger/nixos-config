{
  username,
  ...
}:
{

  boot.initrd.luks.devices = {
    cryptroot.device = "/dev/disk/by-id/nvme-eui.002538da11b3a04c-part2";
    cryptstorage.device = "/dev/disk/by-id/wwn-0x50014ee2153e7621-part1";
  };
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "rw"
      "relatime"
      "ssd_spread"
      "commit=300"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "rw"
      "relatime"
      "ssd_spread"
      "commit=300"
    ];
  };
  fileSystems."/var/log" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [
      "subvol=@log"
      "noatime"
      "rw"
      "ssd_spread"
      "commit=300"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "noatime"
      "rw"
      "ssd_spread"
      "commit=300"
    ];
  };

  fileSystems."/.snapshots" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [
      "subvol=@.snapshots"
      "rw"
      "relatime"
      "ssd_spread"
      "commit=300"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };
  fileSystems."/mnt/sda1" = {
    device = "/dev/disk/by-label/STORAGE";
    fsType = "btrfs";
    options = [
      "x-gvfs-show"
      "x-gvfs-name=HDD%201"
      "rw"
      "relatime"
      "commit=300"
      "autodefrag"
    ];
  };
  # fileSystems."/mnt/win" =
  #   {
  #     device = "/dev/nvme0n1p5";
  #     fsType = "ntfs-3g";
  #     options = [ "rw" "uid=1000" "x-gvfs-show" "x-gvfs-name=Win11" "x-gvfs-icon=windows" "x-gvfs-symbolic-icon=windows" ];
  #   };
  # fileSystems."/mnt/win_hdd" =
  #   {
  #     device = "/dev/sda2";
  #     fsType = "ntfs-3g";
  #     options = [ "rw" "uid=1000" "x-gvfs-show" "x-gvfs-name=WinHDD" ];
  #   };
  fileSystems."/mnt/ccache" = {
    device = "/home/${username}/.cache/ccache";
    options = [
      "defaults"
      "bind"
      "users"
      "noauto"
    ];
  };
  swapDevices = [
    {
      device = "/swap/swapfile";
      priority = 1;
    }
  ];
}
