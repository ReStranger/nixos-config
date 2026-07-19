{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.module.services.ollama;
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.types) package ints;
in {
  options.module.services.ollama = {
    enable = mkEnableOption "Enable ollama daemon";
    package = mkOption {
      type = package;
      description = "Ollama package to use";
      default = pkgs.ollama;
    };
    context = mkOption {
      type = ints.positive;
      description = "Maximum ollama context";
      default = 131072;
    };
  };
  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      openFirewall = config.networking.firewall.enable;
      environmentVariables = {
        OLLAMA_CONTEXT_LENGTH = toString cfg.context;
      };
      inherit (cfg) package;
    };
  };
}
