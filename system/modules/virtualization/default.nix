{ lib
, config
, username
, pkgs
, ...
}:

with lib;

let
  cfg = config.module.virtualisation;
in {
  options = {
    module.virtualisation = {
      enable = mkEnableOption "Enables virtualisation";
      docker.enable = mkEnableOption "Enables docker";
      podman.enable = mkEnableOption "Enables podman";
      libvirtd.enable = mkEnableOption "Enables libvirtd";
      virtualbox.enable = mkEnableOption "Enables virtualbox";
    };
  };

  config = mkIf cfg.enable {
    # Virtualization settings
    environment.systemPackages = with pkgs; [
      virt-manager
    ];

    users.extraGroups.vboxusers.members = [ username ];

    virtualisation = {
      docker = {
        enable = cfg.docker.enable;
        enableOnBoot = false;
        storageDriver = "btrfs";
      };
      podman.enable = cfg.podman.enable;
      libvirtd.enable = cfg.libvirtd.enable;
      virtualbox.host.enable = cfg.virtualbox.enable;
    };
  };
}
