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
    sops = {
      secrets = {
        "bifrost/api_key" = {};
        "bifrost/server_url" = {};
      };

      templates."pi-agent-auth" = {
        path = "${config.programs.pi-coding-agent.configDir}/auth.json";
        mode = "0600";
        content = builtins.toJSON {
          opencode = {
            type = "api_key";
            key = "public";
          };
          bifrost-responses = {
            type = "api_key";
            key = config.sops.placeholder."bifrost/api_key";
            env.BIFROST_BASE_URL = config.sops.placeholder."bifrost/server_url";
          };
          bifrost-completions = {
            type = "api_key";
            key = config.sops.placeholder."bifrost/api_key";
            env.BIFROST_BASE_URL = config.sops.placeholder."bifrost/server_url";
          };
        };
      };
    };

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
          "https://github.com/ReStranger/pi-bifrost-provider"
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
