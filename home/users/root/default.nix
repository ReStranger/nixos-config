{
  isWorkstation,
  ...
}:

{
  stylix.targets = {
    neovim.enable = false;
    zen-browser.enable = false;
  };
  module = {
    stylix.enable = isWorkstation;
    zsh.enable = isWorkstation;

    nix.enable = true;

    btop.enable = true;
    git.enable = true;
    lazygit.enable = true;
    nvim.enable = true;
    sops.enable = true;
    starship.enable = true;
    tmux.enable = true;
    yazi.enable = true;

  };
}
