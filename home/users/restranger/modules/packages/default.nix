{
  config,
  lib,
  pkgs,
  inputs,
  isLinux,
  isWorkstation,
  hyprlandEnable,
  ...
}: let
  cfg = config.module.user.packages;
  inherit (lib) mkEnableOption mkIf optionals;
in {
  options.module.user.packages = {
    enable = mkEnableOption "Enable user packages";
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    programs = {
      cava.enable = true;
      fd.enable = true;
      jq.enable = true;
      lazydocker.enable = true;
      lsd.enable = true;
      ripgrep.enable = true;
      zoxide.enable = true;
      imv.enable = isWorkstation;
    };

    home.packages = with pkgs;
      [
        ## system tools ##
        unzip
        unrar
        p7zip
        curl
        wget
        lm_sensors
        systemctl-tui

        ## shell ##
        bat

        ## fetch ##
        fastfetch

        ## dev tools ##
        nodejs
        vscode-js-debug
        clang-tools
        llvmPackages_latest.clang
        llvmPackages_latest.lldb

        ## Fonts ##
        corefonts
        vista-fonts
        rubik
        material-symbols
        maple-mono.NF
        nerd-fonts.jetbrains-mono
        nerd-fonts.caskaydia-cove
        nerd-fonts.inconsolata
        nerd-fonts.fira-code
        nerd-fonts.hack
        nerd-fonts.ubuntu
      ]
      ++ optionals isWorkstation [
        onlyoffice-desktopeditors
        krita
        vlc
        inkscape
        qbittorrent
        davinci-resolve_20
        open-design
        xournalpp
        audacity
        obsidian
        (prismlauncher.override {
          additionalPrograms = [
            glfw3-minecraft
            ffmpeg
          ];
        })
        lunar-client
      ]
      ++ optionals (isLinux && isWorkstation) [
        inputs.ayugram-desktop.packages.${pkgs.stdenv.hostPlatform.system}.default
        libnotify
        bottles
        figma-linux
        yabridge
        yabridgectl
      ]
      ++ optionals hyprlandEnable [
        kdePackages.kclock
        kdePackages.kalk
        kdePackages.ark
        wl-clipboard
        wl-clipboard-x11
        overskride
        brightnessctl
        playerctl
        lxqt.pavucontrol-qt
        grimblast
        hyprpicker
      ];
  };
}
