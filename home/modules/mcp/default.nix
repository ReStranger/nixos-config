{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.module.mcp;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.mcp = {
    enable = mkEnableOption "Enable mcp module";
  };

  config = mkIf cfg.enable {
    sops.secrets.github_token = { };
    programs.mcp = {
      enable = true;
      servers = {
        context-mode = {
          type = "local";
          command = "${pkgs.context-mode}/bin/context-mode";
        };
        github = {
          type = "http";
          url = "https://api.githubcopilot.com/mcp/";
          headers = {
            Authorization = "Bearer {file:${config.sops.secrets.github_token.path}}";
          };
        };
        mcp-nixos = {
          url = "http://localhost:3229/mcp";
        };

        web-search = {
          url = "http://localhost:3228/mcp";
        };
      };
    };
  };
}
