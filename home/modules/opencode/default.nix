{
  config,
  lib,
  ...
}:

let
  cfg = config.module.opencode;
  inherit (lib) mkEnableOption mkIf genAttrs;
  secrets = [
    "openai_api_key"
    "openrouter_api_key"
  ];
in
{
  options.module.opencode = {
    enable = mkEnableOption "Enable opencode program";
  };

  config = mkIf cfg.enable {
    sops.secrets = genAttrs secrets (_: { });
    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
      settings =
        let
          secret = genAttrs secrets (name: "{file:${config.sops.secrets.${name}.path}}");
        in
        {
          provider = {
            weegam_openai = {
              name = "Weegam (OpenAI)";
              npm = "@ai-sdk/openai-compatible";
              options = {
                apiKey = secret.openai_api_key;
                baseURL = "https://api.weegam.com/uni/v1";
              };
              models = {
                "gpt-5.2-2025-12-11" = {
                  _launch = true;
                  name = "gpt-5.2";
                };
              };
            };
          };
        };
    };
  };
}
