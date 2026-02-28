{
  pkgs,
  inputs,
  isWorkstation,
  isLinux,
  hyprlandEnable ? false,
  ...
}:

{
  stylix.targets = {
    neovim.enable = false;
    zen-browser.enable = false;
  };
  module = {
    mcp.enable = isWorkstation;
    mcp-servers = {
      enable = isWorkstation;
      servers = {
        open-web-search = {
          enable = true;
          package = pkgs.open-websearch;
          env = {
            DEFAULT_SEARCH_ENGINE = "duckduckgo";
            PORT = "3228";
          };
        };

        mcp-nixos = {
          enable = true;
          package = inputs.mcp-nixos.packages.${pkgs.stdenv.hostPlatform.system}.default;
          env = {
            MCP_NIXOS_TRANSPORT = "http";
            MCP_NIXOS_HOST = "127.0.0.1";
            MCP_NIXOS_PORT = "3229";
            MCP_NIXOS_PATH = "/mcp";
          };
        };
      };
    };
    opencode.enable = isWorkstation;
    zathura.enable = isWorkstation;
    stylix.enable = isWorkstation;
    thunderbird.enable = isWorkstation;
    zsh.enable = isWorkstation;
    zen-browser.enable = isWorkstation;

    dconf.enable = isLinux && isWorkstation;
    xdg-user-dirs.enable = isLinux && isWorkstation;
    gtk.enable = isLinux && isWorkstation;
    mangohud.enable = isLinux && isWorkstation;
    wezterm.enable = isLinux && isWorkstation;

    anyrun.enable = hyprlandEnable && isLinux && isWorkstation;
    discord.enable = hyprlandEnable && isLinux && isWorkstation;
    kidex.enable = hyprlandEnable && isLinux && isWorkstation;
    nautilus.enable = hyprlandEnable && isLinux && isWorkstation;
    hyprland.enable = hyprlandEnable && isLinux && isWorkstation;
    quickshell.enable = hyprlandEnable && isLinux && isWorkstation;

    nix.enable = true;

    btop.enable = true;
    git.enable = true;
    lazygit.enable = true;
    nvim.enable = true;
    sops.enable = true;
    starship.enable = true;
    tmux.enable = true;
    yazi.enable = true;

    user = {
      xdg.enable = isLinux && isWorkstation;
      packages.enable = true;
    };
  };
}
