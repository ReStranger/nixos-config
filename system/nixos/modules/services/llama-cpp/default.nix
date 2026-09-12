{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.module.services.llama-cpp;
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.types) anything attrsOf ints package port str;
in {
  options.module.services.llama-cpp = {
    enable = mkEnableOption "Enable llama.cpp inference server";

    package = mkOption {
      type = package;
      description = "llama.cpp package to use";
      default = pkgs.llama-cpp;
    };

    host = mkOption {
      type = str;
      description = "IP address to listen on";
      default = "0.0.0.0";
    };

    port = mkOption {
      type = port;
      description = "HTTP server port";
      default = 11435;
    };
    parallel = mkOption {
      type = ints.positive;
      description = "Number of parallel request slots exposed by llama-server";
      default = 1;
    };

    extraSettings = mkOption {
      type = attrsOf anything;
      description = "Extra settings passed to llama-server (see services.llama-cpp.settings)";
      default = {};
    };
  };

  config = mkIf cfg.enable {
    services.llama-cpp = {
      enable = true;
      inherit (cfg) package;
      openFirewall = config.networking.firewall.enable;
      settings =
        {
          inherit (cfg) host;
          inherit (cfg) port;
          inherit (cfg) parallel;
        }
        // cfg.extraSettings;
    };

    # Fix shader cache path and relax hardening for GPU
    systemd.services.llama-cpp.serviceConfig = {
      Environment = [
        "HOME=/var/cache/llama-cpp"
        "XDG_CACHE_HOME=/var/cache/llama-cpp"
      ];
    };
  };
}
