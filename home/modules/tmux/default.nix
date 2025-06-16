{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.module.tmux;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.module.tmux = {
    enable = mkEnableOption "Enable tmux module";
  };

  config = mkIf cfg.enable {

    programs.tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "tmux-256color";
      historyLimit = 100000;
      plugins = [
        pkgs.tmuxPlugins.sensible
        pkgs.tmuxPlugins.vim-tmux-navigator
        pkgs.tmuxPlugins.resurrect
        pkgs.tmuxPlugins.continuum
        pkgs.tmuxPlugins.sessionist
        { plugin = inputs.minimal-tmux.packages.${pkgs.system}.default; }
      ];
      baseIndex = 1;
      mouse = true;
      keyMode = "vi";
      shortcut = "a";
      extraConfig = ''
              set-option -ga terminal-overrides ",$TERM:Tc"
              set -g default-terminal "$TERM"

              # Сортировка по имени
              bind s choose-tree -sZ -O name

              # Переназначение клавиш
              unbind %
              bind b split-window -h 

              unbind '"'
              bind v split-window -v

              bind -r j resize-pane -D 5
              bind -r k resize-pane -U 5
              bind -r l resize-pane -R 5
              bind -r h resize-pane -L 5

              bind -r m resize-pane -Z

              is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
            | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
              bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
              bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
              bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
              bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
              tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
        if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
            "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
        if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
            "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"
              bind-key -T copy-mode-vi 'C-h' select-pane -L
              bind-key -T copy-mode-vi 'C-j' select-pane -D
              bind-key -T copy-mode-vi 'C-k' select-pane -U
              bind-key -T copy-mode-vi 'C-l' select-pane -R
              bind-key -T copy-mode-vi 'C-\' select-pane -l
              bind-key -T copy-mode-vi 'v' send -X begin-selection 
              bind-key -T copy-mode-vi 'y' send -X copy-selection 

              unbind -T copy-mode-vi MouseDragEnd1Pane

              set -g @resurrect-capture-pane-contents 'on'
      '';
    };
  };
}
