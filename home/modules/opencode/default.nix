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
                  reasoning = true;
                  tool_call = true;
                  temperature = true;
                  limit = {
                    context = 1048576;
                    output = 65536;
                  };
                  variants = {
                    high = {
                      thinkingConfig = {
                        thinkingBudget = 24576;
                      };
                    };
                    low = {
                      thinkingConfig = {
                        thinkingBudget = 2048;
                      };
                    };
                  };
                };
                "gemini-2.5-pro" = {
                  name = "Gemini 2.5 Pro";
                  reasoning = true;
                  tool_call = true;
                  temperature = true;
                  limit = {
                    context = 1048576;
                    output = 65536;
                  };
                  variants = {
                    high = {
                      thinkingConfig = {
                        thinkingBudget = 32768;
                      };
                    };
                    low = {
                      thinkingConfig = {
                        thinkingBudget = 4096;
                      };
                    };
                  };
                };
                "gemini-3-flash-preview" = {
                  name = "Gemini 3 Flash Preview";
                  reasoning = true;
                  tool_call = true;
                  temperature = true;
                  limit = {
                    context = 1048576;
                    output = 65536;
                  };
                  variants = {
                    high = {
                      thinkingConfig = {
                        thinkingLevel = "high";
                      };
                    };
                    low = {
                      thinkingConfig = {
                        thinkingLevel = "low";
                      };
                    };
                  };
                };
                "gemini-3-pro-image-preview" = {
                  name = "Gemini 3 Pro Image Preview";
                  reasoning = true;
                  tool_call = true;
                  attachment = true;
                  temperature = true;
                  limit = {
                    context = 1048576;
                    output = 65536;
                  };
                };
                "gemini-3-pro-preview" = {
                  name = "Gemini 3 Pro Preview";
                  reasoning = true;
                  tool_call = true;
                  temperature = true;
                  limit = {
                    context = 1048576;
                    output = 65536;
                  };
                  variants = {
                    high = {
                      thinkingConfig = {
                        thinkingLevel = "high";
                      };
                    };
                    low = {
                      thinkingConfig = {
                        thinkingLevel = "low";
                      };
                    };
                  };
                };
                "gemini-3.1-pro-preview" = {
                  name = "Gemini 3.1 Pro Preview";
                  reasoning = true;
                  tool_call = true;
                  temperature = true;
                  limit = {
                    context = 1048576;
                    output = 65536;
                  };
                  variants = {
                    high = {
                      thinkingConfig = {
                        thinkingLevel = "high";
                      };
                    };
                    low = {
                      thinkingConfig = {
                        thinkingLevel = "low";
                      };
                    };
                  };
                };
                "gpt-4-turbo-2024-04-09" = {
                  name = "GPT-4 Turbo 2024-04-09";
                  reasoning = true;
                  tool_call = true;
                  temperature = true;
                  limit = {
                    context = 1047576;
                    output = 32768;
                  };
                  variants = {
                    high = {
                      temperature = 0.7;
                    };
                    low = {
                      temperature = 0.2;
                    };
                  };
                };
                "gpt-4.1-2025-04-14" = {
                  name = "GPT-4.1 2025-04-14";
                  reasoning = true;
                  tool_call = true;
                  temperature = true;
                  limit = {
                    context = 1047576;
                    output = 32768;
                  };
                  variants = {
                    high = {
                      temperature = 0.7;
                    };
                    low = {
                      temperature = 0.2;
                    };
                  };
                };
                "gpt-4.1-nano-2025-04-14" = {
                  name = "GPT-4.1 Nano 2025-04-14";
                  reasoning = true;
                  tool_call = true;
                  temperature = true;
                  limit = {
                    context = 1047576;
                    output = 32768;
                  };
                  variants = {
                    high = {
                      temperature = 0.7;
                    };
                    low = {
                      temperature = 0.2;
                    };
                  };
                };
                "gpt-4o-2024-05-13" = {
                  name = "GPT-4o 2024-05-13";
                  reasoning = true;
                  tool_call = true;
                  temperature = true;
                  limit = {
                    context = 1047576;
                    output = 32768;
                  };
                  variants = {
                    high = {
                      temperature = 0.7;
                    };
                    low = {
                      temperature = 0.2;
                    };
                  };
                };
                "gpt-4o-2024-08-06" = {
                  name = "GPT-4o 2024-08-06";
                  reasoning = true;
                  tool_call = true;
                  temperature = true;
                  limit = {
                    context = 1047576;
                    output = 32768;
                  };
                  variants = {
                    high = {
                      temperature = 0.7;
                    };
                    low = {
                      temperature = 0.2;
                    };
                  };
                };
                "gpt-4o-2024-11-20" = {
                  name = "GPT-4o 2024-11-20";
                  reasoning = true;
                  tool_call = true;
                  temperature = true;
                  limit = {
                    context = 1047576;
                    output = 32768;
                  };
                  variants = {
                    high = {
                      temperature = 0.7;
                    };
                    low = {
                      temperature = 0.2;
                    };
                  };
                };
                "gpt-5-2025-08-07" = {
                  name = "GPT-5 2025-08-07";
                  reasoning = true;
                  tool_call = true;
                  temperature = true;
                  limit = {
                    context = 1047576;
                    output = 32768;
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
                "gpt-5-mini-2025-08-07" = {
                  name = "GPT-5 Mini 2025-08-07";
                  reasoning = true;
                  tool_call = true;
                  temperature = true;
                  limit = {
                    context = 1047576;
                    output = 32768;
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
                "gpt-5.1-2025-11-13" = {
                  name = "GPT-5.1 2025-11-13";
                  reasoning = true;
                  tool_call = true;
                  temperature = true;
                  limit = {
                    context = 1047576;
                    output = 65536;
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
                "gpt-5.2-2025-12-11" = {
                  name = "GPT-5.2 2025-12-11";
                  reasoning = true;
                  tool_call = true;
                  temperature = true;
                  limit = {
                    context = 1047576;
                    output = 65536;
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
                    };
                    none = {
                      reasoningEffort = "none";
                    };
                  };
                };
                "gpt-5.2-codex" = {
                  name = "GPT-5.2 Codex";
                  reasoning = true;
                  tool_call = true;
                  temperature = true;
                  limit = {
                    context = 1047576;
                    output = 65536;
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
                    };
                    none = {
                      reasoningEffort = "none";
                    };
                  };
                };
                "gpt-5.2-codex-openai-compact" = {
                  name = "GPT-5.2 Codex OpenAI Compact";
                  reasoning = true;
                  tool_call = true;
                  temperature = true;
                  limit = {
                    context = 1047576;
                    output = 65536;
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
                    };
                    none = {
                      reasoningEffort = "none";
                    };
                  };
                };
                "gpt-5.2-openai-compact" = {
                  name = "GPT-5.2 OpenAI Compact";
                  reasoning = true;
                  tool_call = true;
                  temperature = true;
                  limit = {
                    context = 1047576;
                    output = 65536;
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
                    };
                    none = {
                      reasoningEffort = "none";
                    };
                  };
                };
                "gpt-5.2-pro-2025-12-11" = {
                  name = "GPT-5.2 Pro 2025-12-11";
                  reasoning = true;
                  tool_call = true;
                  temperature = true;
                  limit = {
                    context = 1047576;
                    output = 65536;
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
                    };
                    none = {
                      reasoningEffort = "none";
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
