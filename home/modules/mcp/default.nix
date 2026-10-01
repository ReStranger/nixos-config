{
  config,
  lib,
  ...
}: let
  cfg = config.module.mcp;
  inherit (lib) mkEnableOption mkIf;
in {
  options.module.mcp = {
    enable = mkEnableOption "Enable mcp module";
  };

  config = mkIf cfg.enable {
    programs.mcp = {
      enable = true;
      servers = {
        mcp-nixos.url = "http://localhost:3229/mcp";
        playwright.url = "http://localhost:3230/mcp";
        web-search.url = "http://localhost:3228/mcp";
        open-design.url = "http://127.0.0.1:7456";
      };
    };
  };
}
