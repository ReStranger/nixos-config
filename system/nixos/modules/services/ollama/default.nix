{
  lib,
  config,
  ...
}:

let
  cfg = config.module.services.ollama;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.services.ollama.enable = mkEnableOption "Enable ollama daemon";
  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      openFirewall = true;
    };
  };
}
