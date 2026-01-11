{
  lib,
  config,
  pkgs,
  username,
  ...
}:
let
  cfg = config.module.adb;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.adb.enable = mkEnableOption "Enable android debug bridge";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ android-tools ];
    users.users.${username}.extraGroups = [ "adbusers" ];
  };
}
