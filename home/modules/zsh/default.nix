{
  config,
  inputs,
  username,
  lib,
  ...
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
      plugins = with inputs; [
        {
          name = "zsh-autosuggestions";
          file = "zsh-autosuggestions.plugin.zsh";
          src = zsh-autosuggestions;
        }
        {
          name = "zsh-completions";
          file = "zsh-completions.plugin.zsh";
          src = zsh-autosuggestions;
        }
        {
          name = "zsh-syntax-highlighting";
          file = "zsh-syntax-highlighting.plugin.zsh";
          src = zsh-syntax-highlighting;
        }
        {
          name = "fzf-tab";
          file = "fzf-tab.plugin.zsh";
          src = fzf-tab;
        }
        {
          name = "zsh-auto-notify";
          file = "auto-notify.plugin.zsh";
          src = zsh-auto-notify;
        }
        {
          name = "zsh-autopair";
          file = "zsh-autopair.plugin.zsh";
          src = zsh-autopair;
        }
        {
          name = "zsh-vi-mode";
          file = "zsh-vi-mode.plugin.zsh";
          src = zsh-vi-mode;
        }

      ];
      shellAliases = {
        "lg" = "lazygit";
        "cat" = "bat --style=plain";
        "tmux" = "tmux -u";
        "uwufetch" = "uwufetch -i";
        "mkvenv" = "python -m venv .venv && source .venv/bin/activate";
        ";:q" = "exit";
        "Жй" = "exit";
        ":Q" = "exit";
        "ЖЙ" = "exit";
        "find.trash" =
          "sudo find / | grep -vE '/home/${username}/.cache|/home/${username}/.icons|/root/.cache|/root/.icons|/var/log|/tmp' | rg";
      };
      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        OPENAI_API_KEY = "$(cat ${config.sops.secrets."openai_key".path})";
      };
      initExtra =
        with config.lib.stylix.colors; # zsh
        ''
          export KEYTIMEOUT=1
          ZVM_INIT_MODE=sourcing
          ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_NEX
          ZVM_VI_INSERT_ESCAPE_BINDKEY=jj
          ZVM_VI_HIGHLIGHT_FOREGROUND=#BAC2DE
          ZVM_VI_HIGHLIGHT_BACKGROUND=#2F2E3E

          autoload -Uz compinit && compinit -d "$HOME/.cache/zcompdump"

          bindkey "^[OA" history-beginning-search-backward
          bindkey "^[OB" history-beginning-search-forward
          bindkey -M vicmd "k" history-beginning-search-backward
          bindkey -M vicmd "j" history-beginning-search-forward
          bindkey -M vicmd "k" history-beginning-search-backward
          bindkey -M vicmd "j" history-beginning-search-forward
          bindkey -M vicmd '?' history-incremental-search-backward
          bindkey -M vicmd '/' history-incremental-search-forward

          export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#${base03}"

          export AUTO_NOTIFY_THRESHOLD=300
          AUTO_NOTIFY_IGNORE+=("docker" "lazygit" "lg" "nvim" "vi" "yazi" "yy")
          export EDITOR=nvim
          export VISUAL=nvim

          HISTDUP=erase
          HISTFILE=~/.local/share/.zsh_history
          setopt appendhistory
          setopt sharehistory
          setopt hist_ignore_space
          setopt hist_ignore_all_dups
          setopt hist_save_no_dups
          setopt hist_ignore_dups
          setopt hist_find_no_dups

          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
          zstyle ':completion:*' list-colors "$${(s.:.)LS_COLORS}"
          zstyle ':completion:*' menu no
          zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd --color=always $realpath'
          zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'lsd --color=always $realpath'
                zstyle ":fzf-tab:*" fzf-flags \
                  -e \
                  -i \
                  --algo=v1 \
                  --no-mouse \
                  -m \
                  --height=20 \
                  --reverse \
                  --no-scrollbar \
                  --pointer=">"
        '';
    };
  };
}
