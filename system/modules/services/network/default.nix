{ lib
  , config
  , hostname
  , ...
}:
with lib;
let
  cfg = config.modules.services.network;
in
{
  options.modules.services.network = {
    enable = mkEnableOption "Enable network service configuration";
    package = mkPackageOption pkgs "networkmanager" { };
    wifi = {
      backend = mkOption {
        type = types.enum [
          "wpa_supplicant"
          "iwd"
        ];
        default = "networkmanager";
        description = ''
          Select default networkmanager of internet configuration
        '';
      };
      firewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable firewall
        '';
      };
      macAddress = mkOption {
        type = types.string;
        default = "preserve";
        example = ''
          "00:11:22:33:44:55", "permanent", "preserve", "random", "stable", "stable-ssid"
        '';
        description = ''
          Set the MAC address of the interface
        '';
        
      };
    };
  };
  config = mkIf cfg.enable {
    networking = {
      hostName = "${hostname}";
      networkmanager = {
        enable = true;
        wifi.backend = cfg.backend;
        wifi.macAddress = cfg.macAddress;
      };
      firewall.enable = false;
      useDHCP = lib.mkDefault true;
    };
  };
}
