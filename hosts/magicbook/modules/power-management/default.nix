{
  services.thermald.enable = true;
  services.upower.enable = true;

  imports = [
     #./auto-cpufreq.nix
     #./tlp.nix
     ./power-profiles-deamon.nix
  ];
}
