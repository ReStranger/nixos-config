{
  lib,
  config,
  pkgs,
  hostname,
  ...
}:
let
  cfg = config.module.services.network;
  inherit (lib)
    mkEnableOption
    mkIf
    mkPackageOption
    mkOption
    mkDefault
    mkForce
    ;
  inherit (lib.types) bool enum str;
in
{
  options.module.services.network = {
    enable = mkEnableOption "Enable network service configuration";
    package = mkPackageOption pkgs "networkmanager" { };
    firewall = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable firewall
      '';
    };
    wifi = {
      backend = mkOption {
        type = enum [
          "wpa_supplicant"
          "iwd"
        ];
        default = "wpa_supplicant";
        description = ''
          Select default networkmanager of internet configuration
        '';
      };
      macAddress = mkOption {
        type = str;
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
    boot.initrd.systemd.network.wait-online.enable = false;
    systemd = {
      network.wait-online.enable = false;
      services."NetworkManager-wait-online".wantedBy = mkForce [ ];
    };
    networking = {
      hostName = "${hostname}";
      networkmanager = {
        enable = true;
        wifi = {
          inherit (cfg.wifi) backend;
          inherit (cfg.wifi) macAddress;
        };
      };
      firewall.enable = cfg.firewall;
      hosts = {
        "127.0.0.1" = [ "${hostname}.local" ];
      };
      useDHCP = mkDefault true;
    };
  };
}
