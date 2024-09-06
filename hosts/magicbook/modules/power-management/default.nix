{
  services.thermald.enable = true;
  services.upower.enable = true;
  services.upower.package = pkgs.upower;
  services.upower.percentageLow = 5;
  services.upower.percentageCritical = 10;

  imports = [
    #./auto-cpufreq.nix
    #./tlp.nix
    ./power-profiles-deamon.nix
  ];
}
