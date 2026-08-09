{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.module.opencode2;

  inherit
    (lib)
    getName
    getVersion
    isPath
    literalExpression
    makeBinPath
    mkEnableOption
    mkIf
    mkOption
    nameValuePair
    optionalAttrs
    pathIsDirectory
    mapAttrs
    mapAttrs'
    ;

  inherit (lib.types) nullOr package listOf bool either lines path attrsOf oneOf str;
  inherit (lib.hm.strings) isPathLike;
  inherit (lib.hm.mcp) renderEnv transformMcpServer;

  jsonFormat = pkgs.formats.json {};

  mkStylixTheme = colors: {
    theme = {
      accent = {
        dark = "#${colors.base0F}";
        light = "#${colors.base07}";
      };
      background = {
        dark = "#${colors.base00}";
        light = "#${colors.base06}";
      };
      backgroundElement = {
        dark = "#${colors.base01}";
        light = "#${colors.base04}";
      };
      backgroundPanel = {
        dark = "#${colors.base01}";
        light = "#${colors.base05}";
      };
      border = {
        dark = "#${colors.base02}";
        light = "#${colors.base03}";
      };
      borderActive = {
        dark = "#${colors.base03}";
        light = "#${colors.base02}";
      };
      borderSubtle = {
        dark = "#${colors.base02}";
        light = "#${colors.base03}";
      };
      diffAdded = {
        dark = "#${colors.base0B}";
        light = "#${colors.base0B}";
      };
      diffAddedBg = {
        dark = "#${colors.base01}";
        light = "#${colors.base05}";
      };
      diffAddedLineNumberBg = {
        dark = "#${colors.base01}";
        light = "#${colors.base05}";
      };
      diffContext = {
        dark = "#${colors.base03}";
        light = "#${colors.base03}";
      };
      diffContextBg = {
        dark = "#${colors.base01}";
        light = "#${colors.base05}";
      };
      diffHighlightAdded = {
        dark = "#${colors.base0B}";
        light = "#${colors.base0B}";
      };
      diffHighlightRemoved = {
        dark = "#${colors.base08}";
        light = "#${colors.base08}";
      };
      diffHunkHeader = {
        dark = "#${colors.base03}";
        light = "#${colors.base03}";
      };
      diffLineNumber = {
        dark = "#${colors.base03}";
        light = "#${colors.base04}";
      };
      diffRemoved = {
        dark = "#${colors.base08}";
        light = "#${colors.base08}";
      };
      diffRemovedBg = {
        dark = "#${colors.base01}";
        light = "#${colors.base05}";
      };
      diffRemovedLineNumberBg = {
        dark = "#${colors.base01}";
        light = "#${colors.base05}";
      };
      error = {
        dark = "#${colors.base08}";
        light = "#${colors.base08}";
      };
      info = {
        dark = "#${colors.base0C}";
        light = "#${colors.base0F}";
      };
      markdownBlockQuote = {
        dark = "#${colors.base03}";
        light = "#${colors.base01}";
      };
      markdownCode = {
        dark = "#${colors.base0B}";
        light = "#${colors.base0B}";
      };
      markdownCodeBlock = {
        dark = "#${colors.base01}";
        light = "#${colors.base00}";
      };
      markdownEmph = {
        dark = "#${colors.base0A}";
        light = "#${colors.base09}";
      };
      markdownHeading = {
        dark = "#${colors.base0E}";
        light = "#${colors.base0F}";
      };
      markdownHorizontalRule = {
        dark = "#${colors.base04}";
        light = "#${colors.base03}";
      };
      markdownImage = {
        dark = "#${colors.base0D}";
        light = "#${colors.base0D}";
      };
      markdownImageText = {
        dark = "#${colors.base0C}";
        light = "#${colors.base07}";
      };
      markdownLink = {
        dark = "#${colors.base0D}";
        light = "#${colors.base0D}";
      };
      markdownLinkText = {
        dark = "#${colors.base0C}";
        light = "#${colors.base07}";
      };
      markdownListEnumeration = {
        dark = "#${colors.base0C}";
        light = "#${colors.base07}";
      };
      markdownListItem = {
        dark = "#${colors.base0D}";
        light = "#${colors.base0F}";
      };
      markdownStrong = {
        dark = "#${colors.base09}";
        light = "#${colors.base0A}";
      };
      markdownText = {
        dark = "#${colors.base05}";
        light = "#${colors.base00}";
      };
      primary = {
        dark = "#${colors.base0D}";
        light = "#${colors.base0F}";
      };
      secondary = {
        dark = "#${colors.base0E}";
        light = "#${colors.base0D}";
      };
      success = {
        dark = "#${colors.base0B}";
        light = "#${colors.base0B}";
      };
      syntaxComment = {
        dark = "#${colors.base04}";
        light = "#${colors.base03}";
      };
      syntaxFunction = {
        dark = "#${colors.base0D}";
        light = "#${colors.base0C}";
      };
      syntaxKeyword = {
        dark = "#${colors.base0E}";
        light = "#${colors.base0D}";
      };
      syntaxNumber = {
        dark = "#${colors.base09}";
        light = "#${colors.base0E}";
      };
      syntaxOperator = {
        dark = "#${colors.base0C}";
        light = "#${colors.base0D}";
      };
      syntaxPunctuation = {
        dark = "#${colors.base05}";
        light = "#${colors.base00}";
      };
      syntaxString = {
        dark = "#${colors.base0B}";
        light = "#${colors.base0B}";
      };
      syntaxType = {
        dark = "#${colors.base0A}";
        light = "#${colors.base07}";
      };
      syntaxVariable = {
        dark = "#${colors.base07}";
        light = "#${colors.base07}";
      };
      text = {
        dark = "#${colors.base05}";
        light = "#${colors.base00}";
      };
      textMuted = {
        dark = "#${colors.base04}";
        light = "#${colors.base01}";
      };
      warning = {
        dark = "#${colors.base0A}";
        light = "#${colors.base0A}";
      };
    };
  };

  toOpencodeShape = server: let
    isRemote = server ? url && server.url != null;
    renderedEnv = renderEnv (p: "{file:${p}}") (server.env or {});
  in
    optionalAttrs (server.enabled or null != null) {
      inherit (server) enabled;
    }
    // {
      type =
        if isRemote
        then "remote"
        else "local";
    }
    // (
      if isRemote
      then
        {
          inherit (server) url;
        }
        // optionalAttrs (server.headers or {} != {}) {
          inherit (server) headers;
        }
      else
        {
          command = [server.command] ++ (server.args or []);
        }
        // optionalAttrs (renderedEnv != {}) {
          environment = renderedEnv;
        }
    );

  transformedMcpServers =
    if cfg.enableMcpIntegration && config.programs.mcp.enable && config.programs.mcp.servers != {}
    then
      mapAttrs (
        _: server:
          transformMcpServer {
            inherit server;
            extraTransforms = [toOpencodeShape];
            exclude = [
              "args"
              "env"
            ];
          }
      )
      config.programs.mcp.servers
    else {};

  packageWithExtraPackages =
    if cfg.package != null && cfg.extraPackages != []
    then
      pkgs.symlinkJoin {
        inherit (cfg.package) meta;
        name = "${getName cfg.package}-wrapped-${getVersion cfg.package}";
        paths = [cfg.package];
        preferLocalBuild = true;
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/${cfg.package.meta.mainProgram} \
            --suffix PATH : ${makeBinPath cfg.extraPackages}
        '';
      }
    else cfg.package;
in {
  options.module.opencode2 = {
    enable = mkEnableOption "opencode2";

    package = mkOption {
      type = nullOr package;
      default = pkgs.opencode2;
      defaultText = literalExpression "pkgs.opencode2";
      description = "Package providing the opencode2 executable.";
    };

    extraPackages = mkOption {
      type = listOf package;
      default = [];
      example = literalExpression "[ pkgs.uv ]";
      description = "Extra packages available to OpenCode.";
    };

    enableMcpIntegration = mkOption {
      type = bool;
      default = false;
      description = ''
        Whether to integrate `programs.mcp.servers` into `module.opencode2.settings.mcp`.

        Settings defined directly in `module.opencode2.settings.mcp` take precedence.
      '';
    };

    settings = mkOption {
      inherit (jsonFormat) type;
      default = {};
      example = {
        model = "anthropic/claude-sonnet-4-5";
        share = "manual";
        autoupdate = false;
      };
      description = ''
        Configuration written to `$XDG_CONFIG_HOME/opencode/opencode.json`.
        See <https://v2.opencode.ai/docs/config> for the V2 configuration format.

        The `$schema` field is added automatically.
      '';
    };

    cli = mkOption {
      inherit (jsonFormat) type;
      default = {};
      example = {
        theme = {
          name = "opencode";
          mode = "system";
        };
      };
      description = ''
        TUI configuration written to `$XDG_CONFIG_HOME/opencode/cli.json`.
        This includes theme, keybinds, scroll, diff, and session UI settings.
      '';
    };

    context = mkOption {
      type = either lines path;
      default = "";
      description = ''
        Global instructions written to `$XDG_CONFIG_HOME/opencode/AGENTS.md`.
      '';
    };

    commands = mkOption {
      type = either (attrsOf (either lines path)) path;
      default = {};
      description = ''
        Custom command markdown files for `$XDG_CONFIG_HOME/opencode/commands/`.

        This option can either be an attribute set or a directory path.
      '';
    };

    agents = mkOption {
      type = either (attrsOf (either lines path)) path;
      default = {};
      description = ''
        Custom agent markdown files for `$XDG_CONFIG_HOME/opencode/agents/`.

        This option can either be an attribute set or a directory path.
      '';
    };

    skills = mkOption {
      type = either (attrsOf (oneOf [lines path str])) path;
      default = {};
      description = ''
        Custom skills for `$XDG_CONFIG_HOME/opencode/skills/`.

        This option can either be an attribute set or a directory path.
      '';
    };

    themes = mkOption {
      type = either (attrsOf (either jsonFormat.type path)) path;
      default = {};
      description = ''
        Custom themes for `$XDG_CONFIG_HOME/opencode/themes/`.

        This option can either be an attribute set or a directory path.
      '';
    };

    tools = mkOption {
      type = either (attrsOf (either lines path)) path;
      default = {};
      description = ''
        Custom tools for `$XDG_CONFIG_HOME/opencode/tools/`.

        This option can either be an attribute set or a directory path.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !isPath cfg.commands || pathIsDirectory cfg.commands;
        message = "`module.opencode2.commands` must be a directory when set to a path";
      }
      {
        assertion = !isPath cfg.agents || pathIsDirectory cfg.agents;
        message = "`module.opencode2.agents` must be a directory when set to a path";
      }
      {
        assertion = !isPath cfg.tools || pathIsDirectory cfg.tools;
        message = "`module.opencode2.tools` must be a directory when set to a path";
      }
      {
        assertion = !isPathLike cfg.skills || pathIsDirectory cfg.skills;
        message = "`module.opencode2.skills` must be a directory when set to a path";
      }
      {
        assertion = !isPath cfg.themes || pathIsDirectory cfg.themes;
        message = "`module.opencode2.themes` must be a directory when set to a path";
      }
    ];

    home.packages = mkIf (packageWithExtraPackages != null) [packageWithExtraPackages];

    module.opencode2.themes = mkIf (config ? lib && config.lib ? stylix && config.lib.stylix ? colors) {
      stylix = mkStylixTheme config.lib.stylix.colors;
    };

    xdg.configFile =
      {
        "opencode/opencode.json" = mkIf (cfg.settings != {} || transformedMcpServers != {}) {
          source = let
            mergedMcpServers = transformedMcpServers // (cfg.settings.mcp.servers or {});
            mergedMcp =
              (cfg.settings.mcp or {})
              // optionalAttrs (mergedMcpServers != {}) {
                servers = mergedMcpServers;
              };
            mergedSettings =
              cfg.settings
              // optionalAttrs (mergedMcp != {}) {
                mcp = mergedMcp;
              };
          in
            jsonFormat.generate "opencode.json" ({
                "$schema" = "https://opencode.ai/config.json";
              }
              // mergedSettings);
        };

        "opencode/cli.json" = mkIf (cfg.cli != {}) {
          source = jsonFormat.generate "cli.json" cfg.cli;
        };

        "opencode/AGENTS.md" =
          if isPath cfg.context
          then {source = cfg.context;}
          else
            mkIf (cfg.context != "") {
              text = cfg.context;
            };

        "opencode/commands" = mkIf (isPath cfg.commands) {
          source = cfg.commands;
          recursive = true;
        };

        "opencode/agents" = mkIf (isPath cfg.agents) {
          source = cfg.agents;
          recursive = true;
        };

        "opencode/tools" = mkIf (isPath cfg.tools) {
          source = cfg.tools;
          recursive = true;
        };

        "opencode/skills" = mkIf (isPathLike cfg.skills) {
          source = cfg.skills;
          recursive = true;
        };

        "opencode/themes" = mkIf (isPath cfg.themes) {
          source = cfg.themes;
          recursive = true;
        };
      }
      // optionalAttrs (builtins.isAttrs cfg.commands) (
        mapAttrs' (
          name: content:
            nameValuePair "opencode/commands/${name}.md" (
              if isPath content
              then {source = content;}
              else {text = content;}
            )
        )
        cfg.commands
      )
      // optionalAttrs (builtins.isAttrs cfg.agents) (
        mapAttrs' (
          name: content:
            nameValuePair "opencode/agents/${name}.md" (
              if isPath content
              then {source = content;}
              else {text = content;}
            )
        )
        cfg.agents
      )
      // optionalAttrs (builtins.isAttrs cfg.tools) (
        mapAttrs' (
          name: content:
            nameValuePair "opencode/tools/${name}.ts" (
              if isPath content
              then {source = content;}
              else {text = content;}
            )
        )
        cfg.tools
      )
      // mapAttrs' (
        name: content:
          if isPathLike content && pathIsDirectory content
          then
            nameValuePair "opencode/skills/${name}" {
              source = content;
              recursive = true;
            }
          else
            nameValuePair "opencode/skills/${name}/SKILL.md" (
              if isPathLike content
              then {source = content;}
              else {text = content;}
            )
      ) (
        if builtins.isAttrs cfg.skills
        then cfg.skills
        else {}
      )
      // optionalAttrs (builtins.isAttrs cfg.themes) (
        mapAttrs' (
          name: content:
            nameValuePair "opencode/themes/${name}.json" (
              if isPath content
              then {
                source = content;
              }
              else {
                source = jsonFormat.generate "opencode-${name}.json" content;
              }
            )
        )
        cfg.themes
      );
  };
}
