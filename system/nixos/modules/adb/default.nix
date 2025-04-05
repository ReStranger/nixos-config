{ lib
, config
, ...
}:
let
  cfg = config.module.adb;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.adb.enable = mkEnableOption "Enable android debug bridge";
  config = mkIf cfg.enable {
    programs.adb.enable = true;
    users.users.restranger.extraGroups = [ "adbusers" ];
  };
}
