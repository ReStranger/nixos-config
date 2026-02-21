{
  config,
  lib,
  ...
}:

let
  cfg = config.module.opencode;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.opencode = {
    enable = mkEnableOption "Enable opencode program";
  };

  config = mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      settings = {
        provider = {
          weegam_openai = {
            name = "Weegam (OpenAI)";
            npm = "@ai-sdk/openai-compatible";
            options = {
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
