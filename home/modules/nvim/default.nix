{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.module.nvim;
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
      extraPackages = with pkgs;  [
        # LSP
        lua-language-server
        vscode-langservers-extracted
        typescript-language-server
        clang-tools
        clang
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

        # formatters
        stylua
        prettierd
        black
        nixpkgs-fmt

        # Debuggers
        lldb
      ];
    };
  };
}
