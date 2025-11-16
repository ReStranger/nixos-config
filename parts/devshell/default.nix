{
  perSystem =
    { pkgs, ... }:
    let
      # Warning (from forked gist, was added August 1st 2018):
      # The hardened NixOS kernel disables 32 bit emulation, which made me run into multiple "Exec format error" errors.
      # To fix, use the default kernel, or enable "IA32_EMULATION y" in the kernel config.
      #
      # Created using:
      #   https://gist.github.com/Nadrieril/d006c0d9784ba7eff0b092796d78eb2a
      #   https://gist.github.com/Arian04/bea169c987d46a7f51c63a68bc117472
      #   https://nixos.wiki/wiki/Android#Building_Android_on_NixOS
      #   https://wiki.lineageos.org/devices/bacon/build
      android-fhs-env = pkgs.buildFHSEnv {
        name = "android-env";
        targetPkgs =
          pkgs: with pkgs; [
            # android-tools
            # libxcrypt-legacy # libcrypt.so.1
            freetype # libfreetype.so.6
            fontconfig # java NPE: "sun.awt.FontConfiguration.head" is null
            # yaml-cpp # necessary for some kernels according to a comment on the gist

            # Some of the packages here are probably unecessary but I don't wanna figure out which
            bc
            # binutils
            bison
            ccache
            curl
            flex
            gcc
            git
            git-repo
            git-lfs
            gnumake
            gnupg
            gperf
            imagemagick
            # openjdk8 # INFO: For LineageOS 14.1-15.1
            # openjdk7 # INFO: For LineageOS 11.0-13.0
            elfutils.dev
            libxml2
            libxslt
            lz4
            lzop
            # m4
            # maven # INFO: For LineageOS 13.0
            # nettools
            openssl
            # perl
            pngcrush
            # procps
            protobuf
            # python2 # INFO: For LineageOS 11.0-16.0
            python3 # INFO: For LineageOS 17.1+
            rsync
            schedtool
            SDL
            squashfsTools
            # unzip
            # util-linux
            # wxGTK30
            # xml2
            zip

            zsh
          ];
        multiPkgs =
          pkgs: with pkgs; [
            zlib
            # libc
            # libcxx
            readline
            #
            # libgcc # crtbeginS.o
            # iconv.dev # sys/types.h
          ];
        runScript = "zsh";
        profile = ''
          export ALLOW_NINJA_ENV=true
          export USE_CCACHE=1
          export CCACHE_EXEC=/usr/bin/ccache
          export CCACHE_DIR=/mnt/ccache
          ccache -M 50G
          ccache -o compression=true

          # INFO: For LineageOS 14.1-15.1
          # export ANDROID_JAVA_HOME=#{pkgs.openjdk8.home}sdkmanager install avd

          # INFO: For LineageOS 11.0-13.0
          # export ANDROID_JAVA_HOME=#{pkgs.openjdk7.home}sdkmanager install avd

          # Building involves a phase of unzipping large files into a temporary directory
          export TMPDIR=/tmp
          clear
          echo -e "\033[1;32m"
          cat << "EOF"
                 ___         _            _    _ 
                | . |._ _  _| | _ _  ___ <_> _| |
                |   || ' |/ . || '_>/ . \| |/ . |
                |_|_||_|_|\___||_|  \___/|_|\___|

                    Welcome to Android Shell!
          EOF
          echo -e "\033[0m"
          echo ""
          echo -e "\033[1;34mСегодня:\033[0m $(date)"
          echo -e "\033[1;34mТекущий пользователь:\033[0m $(whoami)"
          echo ""
          echo -e "\033[1;34m<\033[0m git lfs install \033[1;34m>\033[0m"
          echo -e "\033[1;34m<\033[0m repo init -u <link> -b <branch> --git-lfs --no-clone-bundle --depth 1 \033[1;34m>\033[0m"
          echo -e "\033[1;34m<\033[0m repo sync -c -j$(nproc --all) --no-clone-bundle --optimized-fetch --prune --force-sync --no-tags \033[1;34m>\033[0m"
          echo ""
        '';

      };
      kernel-fhs-env = pkgs.buildFHSEnv {
        name = "kernel-build-env";
        targetPkgs =
          pkgs:
          (
            with pkgs;
            [
              pkg-config
              clang
              lld
              llvm

              ncurses
              elfutils
              zlib

              ccache
              git
              git-repo
              git-lfs
            ]
            ++ pkgs.linux.nativeBuildInputs
          );
        runScript = "zsh";
        profile = ''
          export LLVM=1
          export LLVM_IAS=1
          export ARCH=arm64
          export CROSS_COMPILE=aarch64-unknown-linux-gnu-

          export LD=ld.lld
          export CC=clang
          export AR=llvm-ar
          export NM=llvm-nm
          export RANLIB="llvm-ranlib"
          export PKG_CONFIG_PATH="${pkgs.ncurses.dev}/lib/pkgconfig"
        '';
      };
    in
    {
      # For nix develop
      devShells = {
        default = pkgs.mkShell {
          name = "flake-template";
          meta.description = "DevShell for Flake";

          shellHook = ''
            exec zsh
          '';

          packages = with pkgs; [
            sops
            age
            ssh-to-age
            yazi
            git
            curl
            neovim
            tmux
            fzf
            tmux
            zsh
          ];
        };
        android = pkgs.stdenv.mkDerivation {
          name = "android-env-shell";
          nativeBuildInputs = [ android-fhs-env ];
          shellHook = "exec android-env";
        };
      };
      devShells.kernel = pkgs.stdenv.mkDerivation {
        name = "kernel-env-shell";
        nativeBuildInputs = [ kernel-fhs-env ];
        shellHook = "exec kernel-build-env";
      };
    };
}
