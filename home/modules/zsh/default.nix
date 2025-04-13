{ config
, username
, lib
, ...
}:


let
  cfg = config.module.zsh;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.zsh = {
    enable = mkEnableOption "Enable zsh program";
  };

  config = mkIf cfg.enable { 
    programs.zsh = {
      enable = true;
      history.size = 5000;
      shellAliases = {
        "lg"="lazygit";
        "cat"="bat --style=plain";
        "tmux"="tmux -u";
        "uwufetch"="uwufetch -i";
        "mkvenv"="python -m venv .venv && source .venv/bin/activate";
        ";:q"="exit";
        "Жй"="exit";
        ":Q"="exit";
        "ЖЙ"="exit";
        "find.trash"="sudo find / | grep -vE '/home/${username}/.cache|/home/${username}/.icons|/root/.cache|/root/.icons|/var/log|/tmp' | rg";
      };
      sessionVariables = {
        EDITOR = "nvim";
        OPENAI_API_KEY = "$(cat ${config.sops.secrets."openai_key".path})";
      };
    };
  };
}
