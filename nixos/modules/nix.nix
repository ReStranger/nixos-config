{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
  };
}
