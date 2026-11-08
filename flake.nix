{
  description = "ReStranger's nix system configuration";

  outputs = {
    self,
    flake-parts,
    ...
  } @ inputs: let
    hosts = import ./hosts.nix;
    libx = import ./lib {inherit self inputs;};
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = libx.forAllSystems;

      imports = [
        (import ./parts libx)
        # ./docs
      ];
      flake = {
        nixosConfigurations = libx.genNixos hosts.nixos;
      };
    };

  inputs = {
    nixpkgs.follows = "unstable";

    stable.url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.xz";
    unstable.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
    master.url = "github:NixOS/nixpkgs/master";

    davinci-nixpkgs.url = "github:NixOS/nixpkgs/2efa67fd26b6df417c33e4603185c701f260dd83";

    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.1.*";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
      inputs.nix.inputs.flake-parts.follows = "flake-parts";
    };

    disko = {
      url = "https://flakehub.com/f/nix-community/disko/*";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "https://flakehub.com/f/danth/stylix/*";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "https://flakehub.com/f/hercules-ci/flake-parts/*";
    treefmt-nix.url = "https://flakehub.com/f/numtide/treefmt-nix/*";

    nix-topology.url = "https://flakehub.com/f/oddlama/nix-topology/*";
    impermanence.url = "https://flakehub.com/f/nix-community/impermanence/*";
    sops-nix.url = "https://flakehub.com/f/Mic92/sops-nix/*";
    ncro = {
      url = "github:feel-co/ncro";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    hyprland.url = "https://flakehub.com/f/hyprwm/Hyprland/*";

    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ayugram-desktop.url = "github:ndfined-crp/ayugram-desktop";
    anyrun.url = "github:anyrun-org/anyrun";
    kidex.url = "github:Kirottu/kidex";
    matugen.url = "github:InioX/Matugen";
    wezterm.url = "github:wez/wezterm?dir=nix";
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
    millennium = {
      url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-millennium.url = "github:re1n0/nixos-millennium/release";

    minimal-tmux.url = "github:niksingh710/minimal-tmux-status";

    opencode.url = "github:anomalyco/opencode/v2";

    tmux-nerd-font-window-name.url = "github:joshmedeski/tmux-nerd-font-window-name";

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    zsh-autosuggestions = {
      url = "github:zsh-users/zsh-autosuggestions";
      flake = false;
    };

    zsh-completions = {
      url = "github:zsh-users/zsh-completions";
      flake = false;
    };

    zsh-syntax-highlighting = {
      url = "github:zsh-users/zsh-syntax-highlighting";
      flake = false;
    };

    fzf-tab = {
      url = "github:Aloxaf/fzf-tab";
      flake = false;
    };

    fzf-zsh-completions = {
      url = "github:chitoku-k/fzf-zsh-completions";
      flake = false;
    };

    zsh-history-substring-search = {
      url = "github:zsh-users/zsh-history-substring-search";
      flake = false;
    };

    zsh-auto-notify = {
      url = "github:MichaelAquilina/zsh-auto-notify";
      flake = false;
    };

    zsh-autopair = {
      url = "github:hlissner/zsh-autopair";
      flake = false;
    };

    zsh-vi-mode = {
      url = "github:jeffreytse/zsh-vi-mode";
      flake = false;
    };
  };
}
