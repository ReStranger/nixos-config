{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.module.pi-coding-agent;
  inherit (lib) mkEnableOption mkIf;
in {
  imports = [./stylix.nix];

  options.module.pi-coding-agent = {
    enable = mkEnableOption "Enable pi-coding-agent module";
  };

  config = mkIf cfg.enable {
    sops.secrets."bifrost/api_key" = {};

    programs.pi-coding-agent = {
      enable = true;
      package = pkgs.pi-bun;
      configDir = "${config.xdg.configHome}/pi/agent";
      extraPackages = with pkgs; [nodejs bun];
      keybindings = {
        "app.thinking.cycle" = ["ctrl+t"];
      };
      settings = {
        theme = "stylix";
        packages = [
          "npm:pi-mcp-adapter"
          "npm:pi-web-access"
          "npm:pi-cc-header"
          "npm:pi-context-view"
          "npm:pi-subagents"
          "npm:pi-cwd-guard"
          "npm:pi-model-sort"
          "npm:pi-lens"
          "npm:@hank-warren/pi-plan-mode"
          "npm:@juicesharp/rpiv-todo"
          "npm:@juicesharp/rpiv-ask-user-question"
          "npm:@juicesharp/rpiv-advisor"
          "npm:@juicesharp/rpiv-btw"
          "npm:@juicesharp/rpiv-i18n"
        ];
        ccHeader = {
          readOnlyConfig = true;
          color = "p";
          ver = 1;
          grad = true;
          lines = true;
          pkg = false;
          speed = 50;
          slogan = "Code something that makes you proud";
          sloganOn = true;
          sloganColor = true;
          disabled = false;
        };
      };

      models = {
        providers = {
          bifrost-responses = {
            baseUrl = "https://bifrost.reworker.lol/v1";
            apiKey = "!cat ${config.sops.secrets."bifrost/api_key".path}";
            api = "openai-responses";
            models = [
              {
                id = "gpt-5.4";
                name = "GPT-5.4";
                reasoning = true;
                input = ["text" "image"];
                contextWindow = 1047576;
                maxTokens = 65536;
                cost = {
                  input = 2.5;
                  output = 15.0;
                  cacheRead = 0.25;
                  cacheWrite = 0.0;
                  tiers = [
                    {
                      inputTokensAbove = 200000;
                      input = 5.0;
                      output = 22.5;
                      cacheRead = 0.5;
                      cacheWrite = 0.0;
                    }
                  ];
                };
              }
              {
                id = "glm-5.2";
                name = "GLM-5.2";
                reasoning = true;
                input = ["text" "image"];
                contextWindow = 1048576;
                maxTokens = 32768;
              }
            ];
          };

          bifrost-completions = {
            baseUrl = "https://bifrost.reworker.lol/v1";
            apiKey = "!cat ${config.sops.secrets."bifrost/api_key".path}";
            api = "openai-completions";
            models = [
              {
                id = "deepseek-v4-flash";
                name = "deepseek-v4-flash";
                reasoning = true;
                input = ["text"];
                contextWindow = 1048576;
                maxTokens = 32768;
              }
            ];
          };
        };
      };
    };

    xdg.configFile."rpiv-i18n/locale.json".text = builtins.toJSON {locale = "ru";};

    home.file = {
      "${config.programs.pi-coding-agent.configDir}/extensions/pi-cwd-guard.json".text = builtins.toJSON {
        allowedOutsideCwdPaths = [
          "/tmp/pi"
          "${pkgs.pi-coding-agent}/lib/node_modules/pi-monorepo"
        ];
      };
      "${config.programs.pi-coding-agent.configDir}/APPEND_SYSTEM.md".source = ./APPEND_SYSTEM.md;
    };
  };
}
