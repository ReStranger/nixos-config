{
  lib
  , config
  , pkgs
  , ...
}:
with lib;
let
  cfg = config.module.nvim;
in {
  options = {
    module.nvim = {
      enable = mkEnableOption "Enable re:nvim module";

      lua = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable lua support for re:nvim
        '';
      };

      rust = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable rust support for re:nvim
        '';
      };
      clang = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable C/C++ support for re:nvim
        '';
      };
      python = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable python support for re:nvim
        '';
      };
      web = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable web support for re:nvim
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; lib.concatLists [
        (if cfg.lua then [
          lua-language-server 
          stylua 
        ] else [])

        (if cfg.rust then [ 
          rustc 
          cargo 
          rust-analyzer 
       ] else [])

        (if cfg.clang then [ 
          clang-tools
          clang
          gcc 
        ] else [])

        (if cfg.python then [ 
          python312
          python312Packages.pip
          pyright
          ruff-lsp
          black
          mypy
          python312Packages.debugpy 
        ] else [])

        (if cfg.web then [ 
          nodejs_22
          pnpm
          vscode-langservers-extracted
          nodePackages_latest.typescript-language-server
          prettierd
          eslint_d
        ] else [])

        [ unzip
          ### LSP ###
          bash-language-server
          marksman
          nixd
          hyprls
          codeium
          ### TOOLS ###
          nixpkgs-fmt
        ]
      ];
    };
  };
}
