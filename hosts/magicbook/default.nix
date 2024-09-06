{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules
      ./packages.nix
    ];

  networking.hostName = "magicbook";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "ru_RU.UTF-8";
  i18n.extraLocaleSettings = {
    LANG = "ru_RU.UTF-8";
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  users.users.restranger = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "input" "networkmanager" ];
    hashedPassword = "$6$/k2DxKT/Biwenuzi$rxMb4alvs9KiBsfrI4UIiTWpTNYgvpvq8jGLl1thkTKX00APg6EPt1E9mO6DgpDHrOjwFWlmLwQiLcIk.w4o20";
  };


  system.stateVersion = "24.05"; # Did you read the comment?
}

