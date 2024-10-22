{
  lib
  , config
  , ...
}:

with lib;

let
  cfg = config.module.services.zerotier-one;
in {
  options.modules.zerotier-one = {
    enable = mkEnableOption "Enable zerotier-one";
    sshd_network = mkOption {
      type = bool;
      default = true;
      description = ''
        Join to my sshd zerotier network
      '';
    };
  };
  config = mkIf cfg.enable {
    zerotierone = {
      enable = true;
      joinNetworks = mkIf cfg.sshd_network [
        "e3918db48305d83a"
      ];
    };
  };
}


