{
  pkgs,
  isWorkstation,
  isLinux,
  hyprlandEnable ? false,
  ...
}: {
  stylix.targets = {
    neovim.enable = false;
    zen-browser.enable = false;
  };
  module = {
    alacritty.enable = isWorkstation;
    ghostty.enable = isWorkstation;
    ida.enable = isWorkstation;
    mcp.enable = isWorkstation;
    mcp-servers = {
      enable = isWorkstation;
      servers = {
        open-web-search = {
          enable = true;
          package = pkgs.open-websearch;
          env = {
            DEFAULT_SEARCH_ENGINE = "duckduckgo";
            USE_PROXY = "true";
            MODE = "http";
            PORT = "3228";
          };
        };

        mcp-nixos = {
          enable = true;
          package = pkgs.mcp-nixos;
          env = {
            MCP_NIXOS_TRANSPORT = "http";
            MCP_NIXOS_HOST = "127.0.0.1";
            MCP_NIXOS_PORT = "3229";
            MCP_NIXOS_PATH = "/mcp";
          };
        };
        playwright = {
          enable = true;
          package = pkgs.playwright-mcp;
          args = ["--host" "127.0.0.1" "--port" "3230"];
        };
      };
    };
    obs-studio.enable = isWorkstation;
    opencode.enable = isWorkstation;
    pi-coding-agent.enable = isWorkstation;
    thunderbird.enable = isWorkstation;
    zathura.enable = isWorkstation;
    zen-browser.enable = isWorkstation;

    dconf.enable = isLinux && isWorkstation;
    gtk.enable = isLinux && isWorkstation;
    kdeconnect.enable = isLinux && isWorkstation;
    mangohud.enable = isLinux && isWorkstation;
    millennium.enable = isLinux && isWorkstation;
    qt.enable = isLinux && isWorkstation;
    showmethekey.enable = isLinux && isWorkstation;
    xdg-user-dirs.enable = isLinux && isWorkstation;

    anyrun.enable = hyprlandEnable && isLinux && isWorkstation;
    discord = {
      enable = hyprlandEnable && isLinux && isWorkstation;
      withVencord = true;
    };
    dolphin.enable = hyprlandEnable && isLinux && isWorkstation;
    kidex.enable = hyprlandEnable && isLinux && isWorkstation;
    hyprland.enable = hyprlandEnable && isLinux && isWorkstation;
    quickshell.enable = hyprlandEnable && isLinux && isWorkstation;

    btop.enable = true;
    cachix.enable = true;
    direnv.enable = true;
    fzf.enable = true;
    git.enable = true;
    lazygit.enable = true;
    nix-your-shell.enable = true;
    nix.enable = true;
    nvim.enable = true;
    sops.enable = true;
    starship.enable = true;
    stylix.enable = true;
    tmux.enable = true;
    variables.enable = true;
    yazi.enable = true;
    zsh.enable = true;

    user = {
      xdg.enable = isLinux && isWorkstation;
      packages.enable = true;
    };
  };
}
