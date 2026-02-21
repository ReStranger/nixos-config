{
  config,
  inputs,
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
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history = {
        size = 5000;
        append = true;
        share = true;
        ignoreSpace = true;
        ignoreAllDups = true;
        ignoreDups = true;
        saveNoDups = true;
        findNoDups = true;
        path = "${config.xdg.dataHome}/zsh/zsh_history";
      };
      plugins = with inputs; [
        {
          name = "zsh-autosuggestions";
          file = "zsh-autosuggestions.plugin.zsh";
          src = zsh-autosuggestions;
        }
        {
          name = "zsh-completions";
          file = "zsh-completions.plugin.zsh";
          src = zsh-completions;
        }
        {
          name = "zsh-syntax-highlighting";
          file = "zsh-syntax-highlighting.plugin.zsh";
          src = zsh-syntax-highlighting;
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = zsh-nix-shell;
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
        ";:q" = "exit";
        "Жй" = "exit";
        ":Q" = "exit";
        "ЖЙ" = "exit";
      };
      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=#${config.lib.stylix.colors.base03}";
        AUTO_NOTIFY_THRESHOLD = 300;
        KEYTIMEOUT = 1;
      };
      initContent = ''
        ZVM_INIT_MODE=sourcing
        ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_NEX
        ZVM_VI_INSERT_ESCAPE_BINDKEY=jj
        ZVM_VI_HIGHLIGHT_FOREGROUND=#${config.lib.stylix.colors.base05}
        ZVM_VI_HIGHLIGHT_BACKGROUND=#${config.lib.stylix.colors.base02}

        bindkey "^[OA" history-beginning-search-backward
        bindkey "^[OB" history-beginning-search-forward
        bindkey -M vicmd "k" history-beginning-search-backward
        bindkey -M vicmd "j" history-beginning-search-forward
        bindkey -M vicmd "k" history-beginning-search-backward
        bindkey -M vicmd "j" history-beginning-search-forward
        bindkey -M vicmd '?' history-incremental-search-backward
        bindkey -M vicmd '/' history-incremental-search-forward
        bindkey "''${key[Up]}" up-line-or-search

        AUTO_NOTIFY_IGNORE+=("docker" "lazygit" "lg" "nvim" "vi" "yazi" "yy" "tmux" "tmate" "nix-shell")

        HISTDUP=erase

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
