{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

let
  cfg = config.module.opencode;
  inherit (lib) mkEnableOption mkIf genAttrs;
  secrets = [
    "openai_api_key"
    "openrouter_api_key"
  ];
in
{
  options.module.opencode = {
    enable = mkEnableOption "Enable opencode program";
  };

  config = mkIf cfg.enable {
    sops.secrets = genAttrs secrets (_: { });

    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
      settings =
        let
          secret = genAttrs secrets (name: "{file:${config.sops.secrets.${name}.path}}");
        in
        {
          plugin = [
            "@zenobius/opencode-background"
            "file://${
              inputs.opencode-background-agents.packages.${pkgs.stdenv.hostPlatform.system}.default
            }/lib/node_modules/kdco-background-agents/dist/plugin/background-agents.js"
          ];
          provider = {
            weegam = {
              name = "Weegam";
              npm = "@ai-sdk/openai-compatible";
              options = {
                apiKey = secret.openai_api_key;
                baseURL = "https://api.weegam.com/uni/v1";
              };
              models = {
                "gemini-2.5-flash" = {
                  name = "Gemini 2.5 Flash";
                };
                "gemini-2.5-pro" = {
                  name = "Gemini 2.5 Pro";
                };
                "gemini-3-flash-preview" = {
                  name = "Gemini 3 Flash Preview";
                };
                "gemini-3-pro-image-preview" = {
                  name = "Gemini 3 Pro Image Preview";
                };
                "gemini-3-pro-preview" = {
                  name = "Gemini 3 Pro Preview";
                };
                "gemini-3.1-pro-preview" = {
                  name = "Gemini 3.1 Pro Preview";
                };
                "gpt-4-turbo-2024-04-09" = {
                  name = "GPT-4 Turbo 2024-04-09";
                };
                "gpt-4.1-2025-04-14" = {
                  name = "GPT-4.1 2025-04-14";
                };
                "gpt-4.1-nano-2025-04-14" = {
                  name = "GPT-4.1 Nano 2025-04-14";
                };
                "gpt-4o-2024-05-13" = {
                  name = "GPT-4o 2024-05-13";
                };
                "gpt-4o-2024-08-06" = {
                  name = "GPT-4o 2024-08-06";
                };
                "gpt-4o-2024-11-20" = {
                  name = "GPT-4o 2024-11-20";
                };
                "gpt-5-2025-08-07" = {
                  name = "GPT-5 2025-08-07";
                };
                "gpt-5-mini-2025-08-07" = {
                  name = "GPT-5 Mini 2025-08-07";
                };
                "gpt-5.1-2025-11-13" = {
                  name = "GPT-5.1 2025-11-13";
                };
                "gpt-5.2-2025-12-11" = {
                  name = "GPT-5.2 2025-12-11";
                };
                "gpt-5.2-codex" = {
                  name = "GPT-5.2 Codex";
                };
                "gpt-5.2-codex-openai-compact" = {
                  name = "GPT-5.2 Codex OpenAI Compact";
                };
                "gpt-5.2-openai-compact" = {
                  name = "GPT-5.2 OpenAI Compact";
                };
                "gpt-5.2-pro-2025-12-11" = {
                  name = "GPT-5.2 Pro 2025-12-11";
                };
              };
            };
            ollama = {
              npm = "@ai-sdk/openai-compatible";
              name = "Ollama (local)";
              options = {
                baseURL = "http://localhost:11434/v1";
              };
            };
            openrouter = {
              options = {
                apiKey = secret.openrouter_api_key;
              };
              models = { };
            };
          };
        };
    };
  };
}
