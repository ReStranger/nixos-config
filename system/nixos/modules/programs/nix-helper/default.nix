{ lib
, config
, username
, ...
}:

with lib;

let
  cfg = config.module.programs.nix-helper;
in
{
  options.module.programs.nix-helper.enable = mkEnableOption "Enables nix-helper";
  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
      flake = "/home/${username}/.config/nix";
    };
  };
}
