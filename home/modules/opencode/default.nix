{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.module.opencode;
  inherit (lib) mkEnableOption mkIf genAttrs;
  secrets = [
    "bifrost/server_url"
    "bifrost/api_key"
    "openrouter_api_key"
  ];
  promptsDir = pkgs.runCommandLocal "opencode-prompts" {} ''
    mkdir -p $out
    cp -r ${./prompts}/* $out/
  '';
in {
  options.module.opencode = {
    enable = mkEnableOption "Enable opencode program";
  };

  config = mkIf cfg.enable {
    sops.secrets = genAttrs secrets (_: {});

    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
      package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings = let
        secret = genAttrs secrets (name: "{file:${config.sops.secrets.${name}.path}}");
      in {
        plugin = [
          "@zenobius/opencode-background"
          "https://github.com/loss-and-quick/opencode-ralph"
          "https://github.com/loss-and-quick/opencode-plugin-advisor"
          "@tarquinen/opencode-dcp@latest"
        ];
        autoshare = false;
        autoupdate = false;
        lsp = true;
        agent = {
          build = {
            color = "secondary";
          };
          plan = {
            color = "primary";
          };
          general = {
            model = "bifrost-response/weegam/gpt-5.4";
          };
          explore = {
            model = "opencode/deepseek-v4-flash-free";
          };
          advisor = {
            model = "bifrost-response/glm-5.2";
          };
          title = {
            model = "bifrost-response/mistral/mistral-small";
          };
          summary = {
            model = "opencode/deepseek-v4-flash-free";
          };
          orchestrator = {
            mode = "primary";
            color = "error";
            description = "Coordinates work by delegating implementation tasks to the minion subagent.";
            prompt = "{file:${promptsDir}/orchestrator.txt}";
          };
          minion = {
            model = "opencode/deepseek-v4-flash-free";
            description = "Subagent that executes focused tasks delegated by Orchestrator.";
            mode = "subagent";
            prompt = "{file:${promptsDir}/minion.txt}";
            permission = {
              task = "deny";
            };
          };
        };
        provider = {
          bifrost-response = {
            name = "Bifrost";
            npm = "@ai-sdk/openai";
            options = {
              apiKey = secret."bifrost/api_key";
              baseURL = secret."bifrost/server_url";
            };
            models = {
              "weegam/gpt-5.4" = {
                name = "GPT-5.4";
                reasoning = true;
                tool_call = true;
                limit = {
                  context = 1047576;
                  output = 65536;
                };
                options = {
                  reasoningEffort = "high";
                  textVerbosity = "low";
                  reasoningSummary = "auto";
                  include = ["reasoning.encrypted_content"];
                };
                variants = {
                  high = {
                    reasoningEffort = "high";
                    textVerbosity = "low";
                    reasoningSummary = "auto";
                  };
                  low = {
                    reasoningEffort = "low";
                    textVerbosity = "low";
                    reasoningSummary = "auto";
                  };
                };
              };
              "charm/glm-5.2" = {
                name = "GLM-5.2";
                reasoning = true;
                tool_call = true;
                limit = {
                  context = 1048576;
                  output = 32768;
                };
                options = {
                  reasoningEffort = "high";
                };
                variants = {
                  high = {
                    reasoningEffort = "high";
                  };
                  low = {
                    reasoningEffort = "low";
                  };
                };
              };
            };
          };
          ollama = {
            npm = "@ai-sdk/openai-compatible";
            name = "Ollama (local)";
            options = {
              baseURL = "http://localhost:11434/v1";
            };
            models = {
              "qwythos-9b:latest" = {
                name = "Qwythos-9B";
                reasoning = true;
                tool_call = true;
              };
            };
          };
        };
        experimental = {};
      };
    };
  };
}
