{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraLuaConfig = ''
    '';
    extraPackages = with pkgs; [
      gcc
      unzip
      rustc
      cargo
      python312
      python312Packages.pip

      ### LSP ###

      lua-language-server
      vscode-langservers-extracted
      nodePackages_latest.typescript-language-server

      rust-analyzer

      pyright
      ruff-lsp

      bash-language-server

      marksman

      nixd

      hyprls

      codeium

      ### TOOLS ###
      stylua

      prettierd
      eslint_d

      black
      mypy
      python312Packages.debugpy

      nixpkgs-fmt
    ];
  };
}
