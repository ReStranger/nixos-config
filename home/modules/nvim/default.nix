{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.module.nvim;
  inherit (lib) mkEnableOption mkIf mkOverride;
in
{
  options = {
    module.nvim = {
      enable = mkEnableOption "Enable re:nvim module";
    };
  };
  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      initLua = mkOverride 10 "";
      extraPackages = with pkgs; [
        # Tools
        ripgrep
        tree-sitter

        # Mason deps
        python313
        nodejs
        luarocks
        luajit

        # LSP
        lua-language-server
        vscode-langservers-extracted
        typescript-language-server
        clang-tools
        neocmakelsp
        qt6.qtdeclarative
        rust-analyzer
        pyright
        ruff
        bash-language-server
        nixd
        docker-language-server
        marksman
        hyprls

        # Linters
        cmake-lint
        clippy
        eslint_d
        mypy
        deadnix
        nix
        hadolint
        shellcheck-minimal
        zsh

        # formatters
        stylua
        prettierd
        black
        nixfmt

        # Debuggers
        llvmPackages_latest.lldb
        vscode-js-debug
      ];
    };
  };
}
