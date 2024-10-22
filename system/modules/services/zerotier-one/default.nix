{
  lib
  , config
  , ...
}:

with lib;

let
  cfg = config.module.services.zerotier-one;
in {
  options.module.services.zerotier-one = {
    enable = mkEnableOption "Enable zerotier-one";
    sshd_network = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Join to my sshd zerotier network
      '';
    };
  };
  config = mkIf cfg.enable {
    services.zerotierone = {
      enable = true;
      joinNetworks = mkIf cfg.sshd_network [
        "e3918db48305d83a"
      ];
    };
  };
}


