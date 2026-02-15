{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.module.services.ollama;
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.types) package;
in
{
  options.module.services.ollama = {
    enable = mkEnableOption "Enable ollama daemon";
    package = mkOption {
      type = package;
      description = "Ollama package to use";
      default = pkgs.ollama;
    };

  };
  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      openFirewall = true;
      inherit (cfg) package;
    };
  };
}
