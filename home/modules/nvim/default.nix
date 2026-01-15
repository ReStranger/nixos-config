{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.module.nvim;
  inherit (lib) mkEnableOption mkIf;
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
      extraLuaPackages = ps: [ ps.magick ];
      extraPackages = with pkgs; [
        # Tools
        ueberzugpp
        imagemagick
        ripgrep
        tree-sitter

        # Mason deps
        python313
        nodejs
        luarocks
        lua5_1

        # LSP
        lua-language-server
        vscode-langservers-extracted
        typescript-language-server
        clang-tools
        cmake-language-server
        qt6.qtdeclarative
        rust-analyzer
        pyright
        ruff
        bash-language-server
        nixd
        marksman
        hyprls

        # Linters
        clippy
        eslint_d
        mypy
        deadnix
        lix
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
