{
  lib,
  config,
  username,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.module.virtualisation;
in
{
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

    users.extraGroups.vboxusers.members = [ username ];

    programs.virt-manager.enable = cfg.libvirtd.enable;

    virtualisation = {
      docker = {
        inherit (cfg.docker) enable;
        enableOnBoot = false;
      };
      podman.enable = cfg.podman.enable;
      libvirtd = {
        inherit (cfg.libvirtd) enable;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
          ovmf.enable = true;
        };
      };
      virtualbox.host.enable = cfg.virtualbox.enable;
    };
  };
}
