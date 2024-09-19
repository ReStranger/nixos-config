{
  imports =
    [
      ./adb.nix
      ./boot.nix
      ./fstab.nix
      # ./greetd.nix
      ./hyprland.nix
      ./locale.nix
      ./networking.nix
      ./nix.nix
      ./pipewire.nix
      ./polkit.nix
      ./power-management
      ./services.nix
      ./timezone.nix
      # ./udev.nix
      ./users.nix
      ./zram.nix
    ];
}
