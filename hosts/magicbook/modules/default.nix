{
  imports =
    [
      ./adb.nix
      ./boot.nix
      ./fstab.nix
      ./greetd-tui.nix
      ./hyprland.nix
      ./locale.nix
      ./networking.nix
      ./nix.nix
      ./pipewire.nix
      ./polkit.nix
      ./power-management
      ./services.nix
      ./timezone.nix
      ./tty.nix
      # ./udev.nix
      ./users.nix
      ./zram.nix
    ];
}
