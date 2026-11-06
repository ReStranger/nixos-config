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
        defaultModel = "antigravity/gemini-3.8-flash:high";
        enabledModels = [
          "antigravity/gemini-3.8-flash:high"
          "opencode-free/glm-5.3-flash-free:max"
          "opencode-free/deepseek-v4.1-flash-free:max"
          "bifrost/weegam/gpt-5.4:xhigh"
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
          "npm:pi-web-access"
          "npm:@restranger/repi-model-fallback"
          "npm:@restranger/repi-subagents"
          "npm:@restranger/repi-permission-system-core"
          "npm:@restranger/repi-permission-system-modes"
          "npm:@restranger/repi-working-enhanced"
          "npm:@restranger/repi-advisor"
          "npm:pi-usage-core"
          "git:github.com/ReStranger/pi-bifrost-provider"
          "git:github.com/ReStranger/pi-opencode-free"
          "git:github.com/ReStranger/pi-oauth-antigravity"
          "npm:pi-token-speed"
          "npm:pi-prefill"
          "npm:pi-context-view"
          "npm:pi-cached-compaction"
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
    };

    home.file = let
      configDir = config.programs.pi-coding-agent.configDir;
      piMonorepoPath = builtins.unsafeDiscardStringContext "${pkgs.pi-bun}/lib/node_modules/pi-monorepo";
    in {
      "${configDir}/APPEND_SYSTEM.md".source = ./APPEND_SYSTEM.md;
      "${configDir}/extensions/pi-permissions.json".text = builtins.toJSON {
        askTimeoutMs = 30000;
        doublePressToConfirm = false;
        "*" = "ask";
        path = {"**" = "allow";};
        bash = {
          "*" = "ask";
          "npm publish*" = "deny";
          "yarn publish*" = "deny";
          "pnpm publish*" = "deny";
          "cargo publish*" = "deny";
          "git push * --force*" = "deny";
          "git push * -f*" = "deny";
        };
        external_directory = {"*" = "ask";};
        external_directory_read = {
          "*" = "ask";
          "/nix/store/*" = "allow";
          "/tmp/pi/*" = "allow";
          "${config.home.homeDirectory}/.agents" = "allow";
          "${config.home.homeDirectory}/.agents/*" = "allow";
          "${piMonorepoPath}" = "allow";
          "${piMonorepoPath}/*" = "allow";
        };
        "external_directory_write" = {
          "/tmp/pi/*" = "allow";
          "*" = "deny";
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
        ];
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
    };
  };
}
