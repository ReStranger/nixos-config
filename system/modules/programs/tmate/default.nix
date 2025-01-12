{ config
, lib
, ...
}:

with lib;

let
  cfg = config.module.programs.tmate;
in
{
  options.module.programs.tmate = {
    enable = mkEnableOption "Enable tmate program";
  };

  config = mkIf cfg.enable {
    services.tmate-ssh-server = {
      enable = true;
    };
  };
}
