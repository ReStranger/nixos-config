{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.module.mcp-servers;

  inherit (lib)
    concatStringsSep
    escapeShellArg
    escapeShellArgs
    filterAttrs
    mapAttrs'
    mapAttrsToList
    mkEnableOption
    mkIf
    mkOption
    nameValuePair
    optionalAttrs
    types
    ;

  serverType = types.submodule (
    { config, name, ... }:
    {
      options = {
        enable = mkEnableOption "MCP server ${name}";

        package = mkOption {
          type = types.nullOr types.package;
          default = null;
          description = "Package that provides the server executable.";
        };

        command = mkOption {
          type = types.str;
          default = config.package.pname;
          description = "Executable name inside package's bin directory.";
        };

        args = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Command line arguments.";
        };

        envSecrets = mkOption {
          type = types.attrsOf types.str;
          default = { };
          description = "Environment variables loaded from files at runtime (VAR = /path/to/secret).";
        };

        env = mkOption {
          type = types.attrsOf types.str;
          default = { };
          description = "Environment variables (plain text).";
        };

        envFile = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Path to an environment file (KEY=VALUE format).";
        };

        workingDirectory = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Working directory for the server.";
        };
      };
    }
  );

  mkExecStart =
    name: serverCfg:
    let
      pkg =
        if serverCfg.package == null then
          throw "module.mcp-servers.servers.${name}.package must be set"
        else
          serverCfg.package;
      secretExports = concatStringsSep "\n" (
        mapAttrsToList (
          varName: secretPath: "export ${varName}=\"$(tr -d '\\n' <${escapeShellArg secretPath})\""
        ) serverCfg.envSecrets
      );
    in
    "${pkgs.writeShellScript "mcp-${name}-start" ''
      set -euo pipefail
      ${secretExports}
      exec ${escapeShellArg "${pkg}/bin/${serverCfg.command}"} ${escapeShellArgs serverCfg.args}
    ''}";

  enabledServers = filterAttrs (_: server: server.enable) cfg.servers;

  mkBaseService = name: serverCfg: {
    Unit = {
      Description = "MCP server ${name}";
    };

    Service = {
      ExecStart = mkExecStart name serverCfg;
      Restart = "on-failure";
      Environment = mapAttrsToList (k: v: "${k}=${v}") serverCfg.env;
    }
    // optionalAttrs (serverCfg.envFile != null) {
      EnvironmentFile = serverCfg.envFile;
    }
    // optionalAttrs (serverCfg.workingDirectory != null) {
      WorkingDirectory = serverCfg.workingDirectory;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  mkService = name: serverCfg: nameValuePair "mcp-${name}" (mkBaseService name serverCfg);
in
{
  options.module.mcp-servers = {
    enable = mkEnableOption "MCP servers infrastructure";

    servers = mkOption {
      type = types.attrsOf serverType;
      default = { };
      description = "MCP server definitions.";
      example = lib.literalExpression ''
        {
          foo = {
            enable = true;
            package = pkgs.foo-mcp-server;
            command = "foo";
            args = [ "stdio" ];
            envSecrets.FOO_TOKEN = config.sops.secrets.foo_token.path;
            env.SOME_VAR = "value";
          };
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = mapAttrsToList (name: serverCfg: {
      assertion = serverCfg.package != null;
      message = "module.services.mcp-servers.servers.${name}.package must be set";
    }) enabledServers;

    systemd.user.services = mapAttrs' mkService enabledServers;
  };
}
