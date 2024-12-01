{ lib
, config
, pkgs
, hostname
, ...
}:
with lib;
let
  cfg = config.module.services.network;
in
{
  options.module.services.network = {
    enable = mkEnableOption "Enable network service configuration";
    package = mkPackageOption pkgs "networkmanager" { };
    firewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable firewall
      '';
    };
    wifi = {
      backend = mkOption {
        type = types.enum [
          "wpa_supplicant"
          "iwd"
        ];
        default = "wpa_supplicant";
        description = ''
          Select default networkmanager of internet configuration
        '';
      };
      macAddress = mkOption {
        type = types.str;
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
        wifi = {
          backend = cfg.wifi.backend;
          macAddress = cfg.wifi.macAddress;
        };
      };
      firewall.enable = cfg.firewall;
      hosts = {
        "127.0.0.1" = [ "pc.local" ];
      };
      useDHCP = lib.mkDefault true;
    };
  };
}
