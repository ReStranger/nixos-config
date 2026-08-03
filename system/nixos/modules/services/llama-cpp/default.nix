{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.module.services.llama-cpp;
  inherit (lib) mkEnableOption mkIf mkOption optionalAttrs;
  inherit (lib.types) package nullOr ints port str;
in {
  options.module.services.llama-cpp = {
    enable = mkEnableOption "Enable llama.cpp inference server";

    package = mkOption {
      type = package;
      description = "llama.cpp package to use";
      default = pkgs.llama-cpp;
    };

    modelAlias = mkOption {
      type = nullOr str;
      description = "Path to a model directory exposed through llama-server aliases";
      default = null;
    };

    port = mkOption {
      type = port;
      description = "HTTP server port";
      default = 11435;
    };

    host = mkOption {
      type = str;
      description = "IP address to listen on";
      default = "0.0.0.0";
    };

    contextSize = mkOption {
      type = ints.positive;
      description = "Context size (KV cache)";
      default = 131072;
    };

    gpuLayers = mkOption {
      type = ints.positive;
      description = "Number of layers to offload to GPU";
      default = 99;
    };

    threads = mkOption {
      type = ints.positive;
      description = "Number of CPU threads for inference";
      default = 6;
    };

    cmoeThreads = mkOption {
      type = nullOr ints.positive;
      description = "Number of MoE CPU expert threads";
      default = null;
    };

    extraSettings = mkOption {
      type = lib.types.attrs;
      description = "Extra settings passed to llama-server (see services.llama-cpp.settings)";
      default = {};
    };
  };

  config = mkIf cfg.enable {
    services.llama-cpp = {
      enable = true;
      inherit (cfg) package;
      openFirewall = true;
      settings =
        {
          inherit (cfg) host;
          inherit (cfg) port;
          n-gpu-layers = cfg.gpuLayers;
          ctx-size = cfg.contextSize;
          inherit (cfg) threads;
          parallel = 1;
        }
        // optionalAttrs (cfg.cmoeThreads != null) {
          n-cpu-moe = cfg.cmoeThreads;
        }
        // optionalAttrs (cfg.modelAlias != null) {
          model-alias = cfg.modelAlias;
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
