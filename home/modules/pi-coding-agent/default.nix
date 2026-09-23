{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.module.pi-coding-agent;
  inherit (lib) mkEnableOption mkIf getExe getVersion;
in {
  imports = [./stylix.nix];

  options.module.pi-coding-agent = {
    enable = mkEnableOption "Enable pi-coding-agent module";
  };

  config = mkIf cfg.enable {
    programs.pi-coding-agent = {
      enable = true;
      package = pkgs.pi-bun;
      configDir = "${config.xdg.configHome}/pi/agent";
      keybindings = {
        "tui.select.up" = ["up" "ctrl+k"];
        "tui.select.down" = ["down" "ctrl+j"];
        "tui.select.pageUp" = ["pageUp" "ctrl+u"];
        "tui.select.pageDown" = ["pageDown" "ctrl+d"];
      };
      settings = {
        lastChangelogVersion = getVersion pkgs.pi-bun;
        defaultProvider = "opencode-free";
        defaultModel = "muse-spark-1.3-contributor-free";
        enabledModels = [
          "bifrost-responses/gpt-5.4"
          "opencode/muse-spark-1.3-contributor-free"
          "bifrost-responses/deepseek-v4-flash"
          "bifrost-responses/glm-5.2"
          "bifrost-responses/glm-5.3"
          "bifrost-responses/gpt-5.5"
          "opencode/nemotron-3-ultra-free"
          "opencode/mimo-v2.5-free"
          "opencode/hy3-free"
        ];
        terminal = {
          clearOnShrink = true;
        };
        showCacheMissNotices = true;
        enableInstallTelemetry = false;
        tuiMode = "fullscreen";
        fullscreenExitOutput = "transcript";
        fullscreenCopyOnSelect = true;
        npmCommand = ["${getExe pkgs.bun}"];
        theme = "stylix";

        packages = [
          "https://github.com/ReStranger/pi-lazy"
          "npm:pi-mcp-adapter"
          "npm:@gotgenes/pi-permission-system"
          "npm:@snowy117/pi-dcp"
          "npm:@juicesharp/rpiv-todo"
          "npm:@juicesharp/rpiv-ask-user-question"
          "npm:@juicesharp/rpiv-i18n"
          "npm:pi-cc-header"
          "https://github.com/ReStranger/pi-bifrost-provider"
          "https://github.com/ReStranger/pi-ui-enhanced"
          "https://github.com/ReStranger/pi-clear-cmd"
          "https://github.com/ReStranger/pi-opencode-free"
          "https://github.com/heyhuynhgiabuu/pi-oauth-antigravity"
          {
            source = "npm:pi-btw";
            extensions = [];
          }
          {
            source = "npm:pi-token-speed";
            extensions = [];
          }
          {
            source = "npm:pi-subagents";
            extensions = [];
          }
          {
            source = "npm:pi-lens";
            extensions = [];
          }
          "npm:@ff-labs/pi-fff"
          {
            source = "npm:pi-web-access";
            extensions = [];
          }
          {
            source = "npm:@hank-warren/pi-plan-mode";
            extensions = [];
          }
          {
            source = "npm:@narumitw/pi-goal";
            extensions = [];
          }
          {
            source = "npm:@narumitw/pi-usage";
            extensions = [];
          }
          {
            source = "npm:@juicesharp/rpiv-advisor";
            extensions = [];
          }
          {
            source = "npm:pi-context-view";
            extensions = [];
          }
        ];
        ccHeader = {
          readOnlyConfig = true;
          color = "p";
          ver = 1;
          grad = true;
          lines = true;
          pkg = true;
          speed = 50;
          slogan = "Code something that makes you proud";
          sloganOn = true;
          sloganColor = true;
          disabled = false;
        };
        subagents.agentOverrides = {
          "cursor-agent".disabled = true;
          "cursor-agent-writer".disabled = true;
          "codex-exec".disabled = true;
          "codex-exec-writer".disabled = true;
          "claude-code".disabled = true;
          "claude-code-writer".disabled = true;
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
        doublePressToConfirm = false;
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
            "/tmp/pi/*" = "allow";
          };
          external_directory_read = {
            "/nix" = "allow";
            "/nix/*" = "allow";
            "${piMonorepoPath}" = "allow";
            "${piMonorepoPath}/*" = "allow";
            "${configDir}/plans" = "allow";
            "${configDir}/plans/*" = "allow";
            "${configDir}/npm/node_modules/pi-subagents" = "allow";
            "${configDir}/npm/node_modules/@hank-warren/pi-plan-mode" = "allow";
            "${configDir}/npm/node_modules/@hank-warren/pi-plan-mode/*" = "allow";
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
      "${configDir}/lazy.json".text = builtins.toJSON {
        version = 1;
        defaults = {lazy = true;};
        auto = true;
        autoLoadLimit = 10;
        afterStartBatchSize = 1;
        afterStartDelayMs = 0;
        afterStartInitialDelayMs = 750;
        afterStartPauseDuringTurn = true;
        afterStartAdaptiveYield = true;
        afterStartPrefetch = true;
        specs = [
          {
            name = "subagents";
            source = "npm:pi-subagents";
            lazy = "after-start";
            priority = 30;
            description = "Subagent orchestration";
          }
          {
            name = "lens";
            source = "npm:pi-lens";
            lazy = "after-start";
            priority = 40;
            description = "Code intelligence (LSP/diagnostics)";
          }
          {
            name = "web";
            source = "npm:pi-web-access";
            lazy = "after-start";
            priority = 50;
          }
          {
            name = "token-speed";
            source = "npm:pi-token-speed";
            lazy = "after-start";
            priority = 60;
          }
          {
            name = "btw";
            source = "npm:pi-btw";
            lazy = true;
            cmd = ["btw"];
          }
          {
            name = "plan";
            source = "npm:@hank-warren/pi-plan-mode";
            lazy = true;
            cmd = ["plan"];
          }
          {
            name = "goal";
            source = "npm:@narumitw/pi-goal";
            lazy = true;
            cmd = ["goal"];
          }
          {
            name = "usage";
            source = "npm:@narumitw/pi-usage";
            lazy = true;
            cmd = ["usage"];
          }
          {
            name = "advisor";
            source = "npm:@juicesharp/rpiv-advisor";
            lazy = true;
            cmd = ["advisor"];
          }
          {
            name = "context";
            source = "npm:pi-context-view";
            lazy = true;
            cmd = ["context"];
          }
        ];
      };
    };
  };
}
