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
        "tui.select.up" = ["up" "k"];
        "tui.select.down" = ["down" "j"];
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
          "npm:pi-btw"
          "npm:@gotgenes/pi-permission-system"
          "npm:@snowy117/pi-dcp"
          "npm:@juicesharp/rpiv-todo"
          "npm:@juicesharp/rpiv-ask-user-question"
          "npm:@juicesharp/rpiv-i18n"
          "npm:pi-cc-header"
          "npm:pi-token-speed"
          {
            source = "npm:pi-subagents";
            extensions = [];
          }
          {
            source = "npm:pi-lens";
            extensions = [];
          }
          {
            source = "npm:@ff-labs/pi-fff";
            extensions = [];
          }
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
          "https://github.com/ReStranger/pi-bifrost-provider"
          "https://github.com/ReStranger/pi-ui-enhanced"
          "https://github.com/ReStranger/pi-working-enhanced"
          "https://github.com/ReStranger/pi-clear-cmd"
          "https://github.com/ReStranger/pi-opencode-free"
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
        autoLoadLimit = 1;
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
            priority = 10;
            tools = ["subagent"];
            keywords = ["delegate" "subagent" "subagents" "in parallel"];
            description = "Subagent orchestration";
          }
          {
            name = "lens";
            source = "npm:pi-lens";
            lazy = "after-start";
            priority = 20;
            description = "Code intelligence (LSP/diagnostics)";
          }
          {
            name = "fff";
            source = "npm:@ff-labs/pi-fff";
            lazy = "after-start";
            priority = 30;
            description = "Fuzzy file finder";
          }
          {
            name = "web";
            source = "npm:pi-web-access";
            lazy = true;
            cmd = ["web"];
            tools = ["web_search" "fetch_content" "get_search_content"];
            keywords = ["web search" "search the web" "fetch url" "youtube"];
            description = "Web search / fetch / video";
          }
          {
            name = "plan";
            source = "npm:@hank-warren/pi-plan-mode";
            lazy = true;
            cmd = ["plan"];
            keywords = ["/plan" "plan mode" "make a plan"];
            description = "Plan mode";
          }
          {
            name = "goal";
            source = "npm:@narumitw/pi-goal";
            lazy = true;
            cmd = ["goal"];
            keywords = ["/goal" "track goals"];
            description = "Goal tracking";
          }
          {
            name = "usage";
            source = "npm:@narumitw/pi-usage";
            lazy = true;
            cmd = ["usage"];
            keywords = ["/usage" "api balance" "check balance"];
            description = "Provider balance / usage";
          }
          {
            name = "advisor";
            source = "npm:@juicesharp/rpiv-advisor";
            lazy = true;
            cmd = ["advisor"];
            keywords = ["/advisor" "second opinion"];
            description = "Second-opinion advisor";
          }
          {
            name = "context";
            source = "npm:pi-context-view";
            lazy = true;
            cmd = ["context"];
            keywords = ["/context"];
            description = "Context viewer";
          }
        ];
      };
    };
  };
}
