{
  lib,
  config,
  username,
  ...
}:

let
  cfg = config.module.services.polkit;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.services.polkit.enable = mkEnableOption "Enable polkit";
  config = mkIf cfg.enable {
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (
          subject.isInGroup("users")
            && (
              action.id == "org.freedesktop.login1.reboot" ||
              action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
              action.id == "org.freedesktop.login1.power-off" ||
              action.id == "org.freedesktop.login1.power-off-multiple-sessions" ||
              action.id == "org.freedesktop.login1.suspend" ||
              action.id == "org.freedesktop.login1.suspend-multiple-sessions"
            )
          )
        {
          return polkit.Result.YES;
        }
      });
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.policykit.exec" &&
            action.lookup("program") == "/etc/profiles/per-user/${username}/bin/showmethekey-cli" &&
            (subject.isInGroup("wheel") || subject.local)) {
            return polkit.Result.YES;
        }
      });
    '';
  };
}
