{
  lib
  , config
  , ...
}:
with lib;
let
  cfg = config.module.adb;
in {
  options = {
    modules.adb.enable = mkEnableOption "Enable android debug bridge";
  };
  config = mkIf cfg.enable {
    programs.adb.enable = true;
    users.users.restranger.extraGroups = ["adbusers"];
  };
}