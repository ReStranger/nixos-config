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
          "llama.cpp" = {
            type = "api_key";
            env.LLAMA_BASE_URL = "http://127.0.0.1:11435";
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
      keybindings = {
        "tui.select.up" = ["up" "k"];
        "tui.select.down" = ["down" "j"];
        "tui.select.pageUp" = ["pageUp" "ctrl+u"];
        "tui.select.pageDown" = ["pageDown" "ctrl+d"];
      };
      settings = {
        terminal = {
          clearOnShrink = true;
        };
        showCacheMissNotices = true;
        enableInstallTelemetry = false;
        tuiMode = "fullscreen";
        fullscreenExitOutput = "transcript";
        fullscreenCopyOnSelect = true;
        theme = "stylix";

        packages = [
          "npm:pi-mcp-adapter"
          "npm:pi-web-access"
          "npm:pi-cc-header"
          "npm:pi-context-view"
          "npm:pi-subagents"
          "npm:@gotgenes/pi-permission-system"
          "npm:pi-lens"
          "npm:@hank-warren/pi-plan-mode"
          "npm:pi-btw"
          "npm:@narumitw/pi-goal"
          "npm:@snowy117/pi-dcp"
          "npm:pi-token-speed"
          "npm:@ff-labs/pi-fff"
          "npm:@juicesharp/rpiv-todo"
          "npm:@juicesharp/rpiv-ask-user-question"
          "npm:@juicesharp/rpiv-advisor"
          "npm:@juicesharp/rpiv-i18n"
          "https://github.com/ReStranger/pi-bifrost-provider"
          "https://github.com/ReStranger/pi-ui-enhanced"
          "https://github.com/ReStranger/pi-working-enhanced"
          "https://github.com/ReStranger/pi-clear-cmd"
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

    home.file = let
      configDir = config.programs.pi-coding-agent.configDir;
      piMonorepoPath = builtins.unsafeDiscardStringContext "${pkgs.pi-bun}/lib/node_modules/pi-monorepo";
    in {
      "${configDir}/APPEND_SYSTEM.md".source = ./APPEND_SYSTEM.md;
      "${configDir}/extensions/pi-permission-system/config.json".text = builtins.toJSON {
        permission = {
          "*" = "allow";
          path = {
            "*" = "allow";
            "*.env" = "deny";
            "*.env.*" = "deny";
            "*.env.example" = "allow";
          };
          bash = {
            "*" = "allow";
            "rm -rf *" = "ask";
            "sudo *" = "ask";
          };
          external_directory = {
            "*" = "ask";
            "/tmp/pi" = "allow";
            "${piMonorepoPath}" = "allow";
            "${configDir}/plans" = "allow";
            "${configDir}/npm/node_modules/pi-subagents" = "allow";
            "${configDir}/npm/node_modules/@hank-warren/pi-plan-mode/docs/plan-craft.md" = "allow";
          };
        };
      };
      "${configDir}/extensions/pi-clear-cmd.json".text = builtins.toJSON {
        hidden = [
          "htg"
          "hi"
          "hi"
          "hc"
          "hv"
          "hm"
          "hdf"
          "hsp"
          "hs"
          "hcl"
          "hps"
          "hpcl"
          "fff-mode"
          "fff-health"
          "fff-rescan"
          "languages"
        ];
      };
      "${configDir}/pi-btw.json".text = builtins.toJSON {thinkingLevel = "minimal";};
      "${configDir}/pi-fff.json".text = builtins.toJSON {
        "$schema" = "https://raw.githubusercontent.com/dmtrKovalenko/fff/main/packages/pi-fff/pi-fff.schema.json";
        mode = "override";
        frecencyDbPath = "${config.home.homeDirectory}/.local/state/pi/fff/frecency";
        historyDbPath = "${config.home.homeDirectory}/.local/state/pi/fff/history";
        enableFsRootScanning = false;
        enableHomeDirScanning = false;
        warnOnHomeDirScan = false;
        followSymlinks = true;
      };
    };
  };
}
