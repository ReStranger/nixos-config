{
  perSystem = { pkgs, ... }: {
    # For nix develop
    devShells.default = pkgs.mkShell {
      name = "flake-template";
      meta.description = "DevShell for Flake";

      shellHook = ''
        exec zsh
      '';

      packages = with pkgs; [
        yazi
        git
        curl
        helix
        fish
        tmux
        lynx
        ripgrep
        htop
        disko
        fzf
      ];
    };
  };
}
