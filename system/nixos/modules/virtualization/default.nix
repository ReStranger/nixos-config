{ lib
, config
, username
, pkgs
, isWorkstation
, ...
}:
let
  cfg = config.module.virtualisation;
  inherit (lib) mkEnableOption mkIf;
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

    programs.virt-manager.enable = cfg.libvirtd.enable && isWorkstation;

    virtualisation = {
      docker.enable = cfg.docker.enable;
      podman.enable = cfg.podman.enable;
      libvirtd = {
        inherit (cfg.libvirtd) enable;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
        };
      };
      virtualbox.host.enable = cfg.virtualbox.enable;
    };
  };
}
