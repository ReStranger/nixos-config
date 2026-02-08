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
      extraLuaPackages = ps: [ ps.magick ];
      extraWrapperArgs = [
        "--suffix"
        "LUA_PATH"
        ";"
        (lib.makeSearchPathOutput "share/lua/5.1" "lib/lua/5.1" [ pkgs.luajitPackages.magick ])
      ];
      extraPackages = with pkgs; [
        # Tools
        imagemagick
        ripgrep
        (callPackage ../../overlays/tree-sitter.nix { })
        pkg-config

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
