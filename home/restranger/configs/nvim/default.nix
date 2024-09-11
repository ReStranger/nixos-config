{
  home.packages = with pkgs; [

    ### LSP ###

    lua-language-server
    nodePackages_latest.vscode-html-languageserver-bin
    nodePackages_latest.vscode-css-languageserver-bin
    nodePackages_latest.typescript-language-server

    clang.tools
    clang

    rust-analyzer

    pyright
    ruff-lsp

    bash-language-server

    marksman

    nil

    hyprls

    ### TOOLS ###
    stylua

    prettierd
    eslint_d

    black
    mypy
    python312Packages.debugpy

    nixpkgs-fmt
  ];
}
