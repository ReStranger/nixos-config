{
  lib,
  config,
  username,
  ...
}:

let
  cfg = config.module.programs.nix-helper;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.programs.nix-helper.enable = mkEnableOption "Enables nix-helper";
  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
      flake = "/home/${username}/.config/nixos";
    };
  };
}
