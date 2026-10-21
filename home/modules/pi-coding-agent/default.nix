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
    sops.secrets.github_token = {};
    home.sessionVariables.PI_PROGRAM_STATUS = 1;
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
        defaultModel = "deepseek-v4.1-flash-free:max";
        enabledModels = [
          "opencode-free/glm-5.3-flash-free:max"
          "opencode-free/deepseek-v4.1-flash-free:max"
          "bifrost/weegam/gpt-5.4:xhigh"
          "antigravity/gemini-3.8-flash:high"
          "antigravity/claude-opus-4-6"
          "antigravity/claude-sonnet-4-6"
          "opencode-free/beam-free:high"
          "bifrost/deepseek-v4-flash"
          "bifrost/glm-5.3"
        ];
        terminal = {
          clearOnShrink = true;
          hyperlinks = "auto";
          images = "auto";
          trueColor = "auto";
        };
        images = {
          autoResize = true;
          blockImages = false;
        };
        showCacheMissNotices = true;
        enableInstallTelemetry = false;
        fullscreenExitOutput = "transcript";
        fullscreenCopyOnSelect = true;
        npmCommand = ["${getExe pkgs.bun}"];
        theme = "stylix";
        collapseChangelog = true;
        cacheWarming = "streaming";

        defaultTools = ["+codemode" "+tool_search"];
        "codemode.mode" = "on";
        "codemode.inlineBudget" = 3000;

        compaction = {
          enabled = true;
          reserveTokens = 16384;
          keepRecentTokens = 20000;
          modelOverrides = {};
        };

        fullscreenWheelScrollLines = "auto";
        fullscreenScrollbar = "auto";

        packages = [
          "npm:@restranger/pi-permission-system"
          "npm:@gotgenes/pi-nocd"
          "npm:@gotgenes/pi-subagents"
          "npm:pi-lens"
          "npm:pi-web-access"
          "npm:@pi-vault/pi-dcp"
          "npm:@juicesharp/rpiv-i18n"
          "npm:@juicesharp/rpiv-todo"
          "npm:@juicesharp/rpiv-ask-user-question"
          "npm:@juicesharp/rpiv-advisor"
          "npm:@juicesharp/rpiv-btw"
          "npm:pi-usage-core"
          "git:github.com/ReStranger/pi-bifrost-provider"
          "git:github.com/ReStranger/pi-opencode-free"
          "git:github.com/ReStranger/pi-oauth-antigravity"
          "npm:@hank-warren/pi-plan-mode"
          "npm:@narumitw/pi-goal"
          "npm:pi-token-speed"
          "npm:pi-context-view"
          "git:github.com/ReStranger/pi-ui-enhanced"
          "git:github.com/ReStranger/pi-working-enhanced"
          "git:github.com/ReStranger/pi-clear-cmd"
          "git:github.com/ReStranger/pi-cc-header"
        ];
        ccHeader = {
          readOnlyConfig = true;
          color = "pi";
          ver = 1;
          grad = false;
          lines = false;
          pkg = true;
          speed = 50;
          slogan = "Code something that makes you proud";
          sloganOn = true;
          sloganColor = true;
          disabled = false;
        };
        tokenSpeed = {
          display = "stats";
          icon = "";
          useProviderTokens = true;
          countStrategy = "direct";
          colors = {
            slow = "#${config.lib.stylix.colors.base08}";
            medium = "#${config.lib.stylix.colors.base09}";
            fast = "#${config.lib.stylix.colors.base0B}";
            blazing = "#${config.lib.stylix.colors.base0C}";
          };
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
      "${configDir}/extensions/pi-lens.json".text = builtins.toJSON {
        widget.visible = false;
        lsp.servers.qmlls = {
          name = "Qt QML Language Server";
          extensions = [".qml"];
          command = "qmlls";
          args = [];
        };
      };
      "${configDir}/extensions/pi-permission-system/config.json".text = builtins.toJSON {
        doublePressToConfirm = false;
        permission = {
          "*" = "allow";
          path = {
            "*" = "allow";
            "*.env" = "deny";
            "*.env.*" = "deny";
            "*.env.example" = "allow";
            "*auth.json" = "deny";
          };
          bash = {
            "*" = "allow";
            "rm -rf *" = "ask";
            "rm -rf /tmp/pi" = "allow";
            "rm -rf /tmp/pi/*" = "allow";
            "sudo *" = "ask";
            "timeout *" = "deny";
            "xargs *" = "deny";
            "env *" = "deny";
            "time *" = "deny";
            "nohup *" = "deny";
            "nice *" = "deny";
            "find -exec" = "deny";
            "fd -x" = "deny";
          };
          external_directory = {
            "*" = "ask";
            "/tmp/pi" = "allow";
            "/tmp/pi/*" = "allow";
          };
          external_directory_read = {
            "/nix" = "allow";
            "/nix/*" = "allow";
            "${config.home.homeDirectory}/.agents" = "allow";
            "${config.home.homeDirectory}/.agents/*" = "allow";
            "${piMonorepoPath}" = "allow";
            "${piMonorepoPath}/*" = "allow";
            "${configDir}/extensions" = "allow";
            "${configDir}/extensions/*" = "allow";
            "${configDir}/git" = "allow";
            "${configDir}/git/*" = "allow";
            "${configDir}/npm" = "allow";
            "${configDir}/npm/*" = "allow";
            "${configDir}/plans" = "allow";
            "${configDir}/plans/*" = "allow";
          };
        };
      };
      "${configDir}/extensions/pi-clear-cmd.json".text = builtins.toJSON {
        hidden = [
          "hc"
          "hcl"
          "hdf"
          "hi"
          "hm"
          "hpcl"
          "hps"
          "hs"
          "hsp"
          "htg"
          "hv"
          "languages"
          "permission-system"
        ];
      };
      "${configDir}/extensions/dcp.json".text = builtins.toJSON {
        compress = {
          minContextLimit = "40%";
          maxContextLimit = "70%";
        };
      };
      "${configDir}/mcp.json".text = builtins.toJSON {
        mcpServers = {
          github = {
            url = "https://api.githubcopilot.com/mcp/";
            description = "Search GitHub repositories and code, read issues and pull requests";
            headers.Authorization = "!echo Bearer $(cat ${config.sops.secrets.github_token.path})";
            toolExposure = {
              get_file_contents = "direct";
              search_code = "direct";
              issue_read = "direct";
              pull_request_read = "direct";
            };
          };
          nixos = {
            url = "http://localhost:3229/mcp";
            description = "Query Nixpkgs packages, versions, and options";
            exposure = "direct";
          };
          playwright = {
            url = "http://localhost:3230/mcp";
            description = "Drive a browser: navigate, click, snapshot, screenshot";
          };
          open-design = {
            url = "http://localhost:7456/mcp";
            description = "Open Design MCP";
          };
        };
      };
      "${configDir}/subagents.json".text = builtins.toJSON {
        maxConcurrent = 50;
        abortAllOnInterrupt = false;
        midRunUpdates = true;
      };
    };
  };
}
