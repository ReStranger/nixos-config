{ config, lib, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe config.programs.hyprland.package}";
        user = "username";
      };
      initial_session = {
        command = "${lib.getExe config.programs.hyprland.package} --config /home/restranger/hyprland.conf";
        user = "greeter";
      };
    };
  };
}

