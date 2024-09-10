{
  imports =
    [
      ./boot.nix
      ./fstab.nix
      # ./greetd.nix
      ./locale.nix
      ./networking.nix
      ./nix.nix
      ./pipewire.nix
      ./polkit.nix
      ./power-management
      ./services.nix
      ./timezone.nix
      ./users.nix
      ./wayland.nix
      ./zram.nix
    ];
}
