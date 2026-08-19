{
  self,
  config,
  inputs,
  pkgs,
  lib,
  username,
  ...
}: let
  cfg = config.module.opencode;
  inherit (lib) genAttrs mkEnableOption mkIf;

  secrets = [
    "bifrost/server_url"
    "bifrost/api_key"
    "openrouter_api_key"
  ];

  agentsDir = ./agents;
in {
  imports = ["${self}/home/modules/opencode2"];

  options.module.opencode = {
    enable = mkEnableOption "Enable opencode program";
  };

  config = mkIf cfg.enable {
    sops.secrets = genAttrs secrets (_: {});
    module.opencode2 = {
      enable = true;
      enableMcpIntegration = true;
      package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
      cli = {
        keybinds = {
          agent_cycle = "tab";
          agent_cycle_reverse = "shift+tab";
          command_list = "ctrl+p";
        };
        theme = {
          name = "stylix";
          mode = "system";
        };
        scroll = {
          speed = 2;
          acceleration = true;
        };
        diffs = {
          wrap = "word";
          view = "auto";
        };
        session = {
          sidebar = "auto";
          scrollbar = false;
          thinking = "show";
          markdown = "rendered";
        };
        animations = true;
        debug = {
          devtools = false;
        };
      };

      settings = let
        secret = genAttrs secrets (name: "{file:${config.sops.secrets.${name}.path}}");
      in {
        inherit username;
        share = "manual";
        autoupdate = false;
        default_agent = "build";
        compaction = {
          auto = true;
          keep = {
            tokens = 8000;
          };
          buffer = 20000;
        };

        attachments = {
          image = {
            auto_resize = true;
            max_width = 2000;
            max_height = 2000;
            max_base64_bytes = 5242880;
          };
        };

        agents = {
          build.color = "#${config.lib.stylix.colors.base0E}";
          plan.color = "#${config.lib.stylix.colors.base0B}";
          orchestrator.color = "#${config.lib.stylix.colors.base08}";
          general = {
            model = "bifrost/gpt-5.4";
          };
          explore = {
            model = "opencode/deepseek-v4-flash-free";
          };
          advisor = {
            model = "llama-cpp/Qwen3.6-35B-A3B-UD-Q3_K_XL";
          };
          title = {
            model = "opencode/deepseek-v4-flash-free";
          };
          summary = {
            model = "opencode/deepseek-v4-flash-free";
          };
        };

        providers = {
          bifrost = {
            name = "Bifrost";
            settings = {
              apiKey = secret."bifrost/api_key";
              baseURL = secret."bifrost/server_url";
            };
            package = "@opencode-ai/ai/providers/openai-compatible";
            models = {
              "gpt-5.4" = {
                name = "GPT-5.4";
                capabilities = {
                  tools = true;
                  input = ["text" "image"];
                  output = ["text"];
                };
                limit = {
                  context = 1047576;
                  output = 65536;
                };
                settings = {
                  reasoningEffort = "high";
                  textVerbosity = "low";
                  reasoningSummary = "auto";
                };
                variants = [
                  {
                    id = "high";
                    settings = {
                      reasoningEffort = "high";
                      textVerbosity = "low";
                      reasoningSummary = "auto";
                    };
                  }
                  {
                    id = "low";
                    settings = {
                      reasoningEffort = "low";
                      textVerbosity = "low";
                      reasoningSummary = "auto";
                    };
                  }
                ];
              };
              "glm-5.2" = {
                name = "GLM-5.2";
                capabilities = {
                  tools = true;
                  input = ["text" "image"];
                  output = ["text"];
                };
                limit = {
                  context = 1048576;
                  output = 32768;
                };
                settings = {
                  reasoningEffort = "high";
                };
                variants = [
                  {
                    id = "high";
                    settings = {
                      reasoningEffort = "high";
                    };
                  }
                  {
                    id = "low";
                    settings = {
                      reasoningEffort = "high";
                    };
                  }
                ];
              };
            };
          };

          llama-cpp = {
            name = "llama.cpp (local)";
            package = "@opencode-ai/ai/providers/openai-compatible";
            settings = {
              apiKey = "llama-cpp";
              baseURL = "http://localhost:11435/v1";
            };
            models = {
              "Qwen3.6-35B-A3B-UD-Q3_K_XL" = {
                name = "Qwen3.6-35B-A3B";
                limit = {
                  context = 65536;
                };
                capabilities = {
                  tools = true;
                  input = ["text"];
                  output = ["text"];
                };
              };
              "Huihui-Qwythos-9B-Claude-Mythos-5-1M-abliterated-Q4_K" = {
                name = "Qwythos-9B-Claude-Mythos";
                limit = {
                  context = 65536;
                };
                capabilities = {
                  tools = true;
                  input = ["text"];
                  output = ["text"];
                };
              };
            };
          };
        };
      };
    };

    xdg.configFile."opencode/agents" = {
      source = agentsDir;
      recursive = true;
    };
  };
}
