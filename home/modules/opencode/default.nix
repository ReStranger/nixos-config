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
    "bifrost/server_url"
    "bifrost/api_key"
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
      package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
      extraPackages = [
        inputs.context-mode.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
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
            "context-mode"
          ];
          autoshare = false;
          autoupdate = false;
          agent = {
            general = {
              model = "bifrost/openai/gpt-5.4";
            };
            explore = {
              model = "bifrost/gemini/gemini-3.1-flash-lite-preview";
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
                "openai/gpt-5.3-codex" = {
                  name = "GPT-5.3 Codex";
                  reasoning = true;
                  tool_call = true;
                  temperature = true;
                  limit = {
                    context = 1047576;
                    output = 65536;
                  };
                  variants = {
                    xhigh = {
                      reasoningEffort = "xhigh";
                      textVerbosity = "low";
                      reasoningSummary = "auto";
                    };
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
                "openai/gpt-5.4" = {
                  name = "GPT-5.4";
                  reasoning = true;
                  tool_call = true;
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
                "openai/gpt-5.4-pro" = {
                  name = "GPT-5.4 Pro";
                  reasoning = true;
                  tool_call = true;
                  limit = {
                    context = 1047576;
                    output = 65536;
                  };
                  variants = {
                    xhigh = {
                      reasoningEffort = "xhigh";
                      textVerbosity = "low";
                      reasoningSummary = "auto";
                    };
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
            bifrost = {
              name = "Bifrost";
              npm = "@ai-sdk/openai-compatible";
              options = {
                apiKey = secret."bifrost/api_key";
                baseURL = secret."bifrost/server_url";
              };
              models = {
                "gemini/gemini-2.5-flash" = {
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
                "gemini/gemini-2.5-pro" = {
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
                "gemini/gemini-3-flash-preview" = {
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
                "gemini/gemini-3-pro-preview" = {
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
                "gemini/gemini-3.1-flash-lite-preview" = {
                  name = "Gemini 3.1 Flash Lite Preview";
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
                "gemini/gemini-3.1-pro-preview" = {
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
                "openai/gpt-5-mini-2025-08-07" = {
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
                "gpt-5.1" = {
                  name = "GPT-5.1";
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
                "openai/gpt-5.2" = {
                  name = "GPT-5.2";
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
          };
          experimental = { };
        };
    };
  };
}
