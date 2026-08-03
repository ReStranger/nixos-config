{
  stdenv,
  lib,
  cacert,
  curl,
  runCommandLocal,
  unzip,
  appimageTools,
  addDriverRunpath,
  dbus,
  libGLU,
  libdrm,
  libarchive,
  libxcrypt,
  libxkbfile,
  libxcb-cursor,
  libxcb-util,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxcb-wm,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxinerama,
  libxrandr,
  libxrender,
  libxt,
  libxtst,
  libxxf86vm,
  libx11,
  libsm,
  libice,
  libxcb,
  buildFHSEnv,
  bash,
  writeText,
  writeShellScript,
  ocl-icd,
  xkeyboard_config,
  glib,
  python3,
  aprutil,
  makeDesktopItem,
  copyDesktopItems,
  jq,
  perl,
  krb5,
  nss,
  studioVariant ? true,
  common-updater-scripts,
  writeShellApplication,
}: let
  davinci = stdenv.mkDerivation rec {
    pname = "davinci-resolve${lib.optionalString studioVariant "-studio"}_20";
    version = "20.0";

    nativeBuildInputs = [
      appimageTools.appimage-exec
      addDriverRunpath
      copyDesktopItems
      unzip
    ];

    # Pretty sure, there are missing dependencies ...
    buildInputs = [
      libGLU
      libxxf86vm
    ];

    src =
      runCommandLocal "davinci-resolve${lib.optionalString studioVariant "-studio"}-src.zip"
      rec {
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash =
          if studioVariant
          then "sha256-q0jfP/DtroK7Dzj/BiB1JmYPihCma/OgcGmQOE/uwGY="
          else "sha256-JM/V449KUEXuQmRpyQC2z9DRmID7hJ3Mnt5N6p/HOXA=";

        impureEnvVars = lib.fetchers.proxyImpureEnvVars;

        nativeBuildInputs = [
          curl
          jq
          perl
        ];

        # ENV VARS
        SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

        # Get linux.downloadId from HTTP response on https://www.blackmagicdesign.com/products/davinciresolve
        REFERID = "263d62f31cbb49e0868005059abcb0c9";
        DOWNLOADSURL = "https://www.blackmagicdesign.com/api/support/us/downloads.json";
        SITEURL = "https://www.blackmagicdesign.com/api/register/us/download";
        PRODUCT = "DaVinci Resolve${lib.optionalString studioVariant " Studio"}";
        VERSION = version;

        USERAGENT = builtins.concatStringsSep " " [
          "User-Agent: Mozilla/5.0 (X11; Linux ${stdenv.hostPlatform.linuxArch})"
          "AppleWebKit/537.36 (KHTML, like Gecko)"
          "Chrome/77.0.3865.75"
          "Safari/537.36"
        ];

        REQJSON = builtins.toJSON {
          "firstname" = "NixOS";
          "lastname" = "Linux";
          "email" = "someone@nixos.org";
          "phone" = "+31 71 452 5670";
          "country" = "nl";
          "street" = "-";
          "state" = "Province of Utrecht";
          "city" = "Utrecht";
          "product" = PRODUCT;
        };
      }
      ''
        DOWNLOADID=$(
          curl --silent --compressed "$DOWNLOADSURL" \
            | jq --raw-output '.downloads[] | .urls.Linux?[]? | select(.downloadTitle | test("^'"$PRODUCT $VERSION"'( Update)?$")) | .downloadId'
        )
        echo "downloadid is $DOWNLOADID"
        test -n "$DOWNLOADID"
        RESOLVEURL=$(curl \
          --silent \
          --header 'Host: www.blackmagicdesign.com' \
          --header 'Accept: application/json, text/plain, */*' \
          --header 'Origin: https://www.blackmagicdesign.com' \
          --header "$USERAGENT" \
          --header 'Content-Type: application/json;charset=UTF-8' \
          --header "Referer: https://www.blackmagicdesign.com/support/download/$REFERID/Linux" \
          --header 'Accept-Encoding: gzip, deflate, br' \
          --header 'Accept-Language: en-US,en;q=0.9' \
          --header 'Authority: www.blackmagicdesign.com' \
          --header 'Cookie: _ga=GA1.2.1849503966.1518103294; _gid=GA1.2.953840595.1518103294' \
          --data-ascii "$REQJSON" \
          --compressed \
          "$SITEURL/$DOWNLOADID")
        echo "resolveurl is $RESOLVEURL"

        curl \
          --retry 3 --retry-delay 3 \
          --header "Upgrade-Insecure-Requests: 1" \
          --header "$USERAGENT" \
          --header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" \
          --header "Accept-Language: en-US,en;q=0.9" \
          --compressed \
          "$RESOLVEURL" \
          > $out
      '';

    # The unpack phase won't generate a directory
    sourceRoot = ".";

    installPhase = let
      appimageName = "DaVinci_Resolve_${lib.optionalString studioVariant "Studio_"}${version}_Linux.run";
    in ''
      runHook preInstall

      export HOME=$PWD/home
      mkdir -p $HOME

      mkdir -p $out
      test -e ${lib.escapeShellArg appimageName}
      appimage-exec.sh -x $out ${lib.escapeShellArg appimageName}

      mkdir -p $out/{"Apple Immersive/Calibration",configs,DolbyVision,easyDCP,Extras,Fairlight,GPUCache,logs,Media,"Resolve Disk Database",.crashreport,.license,.LUT}

      mkdir -p $out/lib/udev/rules.d
      cp $out/share/etc/udev/rules.d/99-BlackmagicDevices.rules $out/lib/udev/rules.d/
      cp $out/share/etc/udev/rules.d/99-ResolveKeyboardHID.rules $out/lib/udev/rules.d/
      cat > $out/lib/udev/rules.d/99-DavinciPanel.rules <<'EOF'
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="096e", MODE="0666"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="096e", MODE="0666"
      EOF
      test -f $out/lib/udev/rules.d/99-BlackmagicDevices.rules
      test -f $out/lib/udev/rules.d/99-ResolveKeyboardHID.rules
      test -f $out/lib/udev/rules.d/99-DavinciPanel.rules

      runHook postInstall
    '';

    dontStrip = true;

    postFixup = ''
      for program in $out/bin/*; do
        isELF "$program" || continue
        addDriverRunpath "$program"
      done

      for program in $out/libs/*; do
        isELF "$program" || continue
        if [[ "$program" != *"libcudnn_cnn_infer"* ]]; then
          echo $program
          addDriverRunpath "$program"
        fi
      done

      ln -s $out/libs/libcrypto.so.1.1 $out/libs/libcrypt.so.1
      ${lib.getExe perl} -pi -e 's/\x74\x11\xe8\x21\x23\x00\x00/\xeb\x11\xe8\x21\x23\x00\x00/g' $out/bin/resolve
    '';

    desktopItems =
      [
        (makeDesktopItem {
          name = "davinci-resolve${lib.optionalString studioVariant "-studio"}";
          desktopName = "Davinci Resolve${lib.optionalString studioVariant " Studio"}";
          genericName = "Video Editor";
          exec = "env QT_QPA_PLATFORM=xcb davinci-resolve${lib.optionalString studioVariant "-studio"}";
          icon = "davinci-resolve${lib.optionalString studioVariant "-studio"}";
          comment = "Professional video editing, color, effects and audio post-processing";
          categories = [
            "AudioVideo"
            "AudioVideoEditing"
            "Video"
            "Graphics"
          ];
          startupWMClass = "resolve";
        })
        (makeDesktopItem {
          name = "blackmagicraw-player";
          desktopName = "Blackmagic RAW Player";
          exec = "blackmagicraw-player %f";
          icon = "blackmagicraw-player";
          mimeTypes = [
            "application/x-braw-clip"
            "application/x-braw-sidecar"
          ];
          categories = [
            "Video"
            "AudioVideo"
          ];
        })
        (makeDesktopItem {
          name = "blackmagicraw-speedtest";
          desktopName = "Blackmagic RAW Speed Test";
          exec = "blackmagicraw-speedtest";
          icon = "blackmagicraw-speedtest";
          categories = [
            "Video"
            "AudioVideo"
          ];
        })
        (makeDesktopItem {
          name = "davinci-control-panels-setup";
          desktopName = "DaVinci Control Panels Setup";
          exec = "davinci-control-panels-setup";
          icon = "davinci-control-panels-setup";
          categories = ["Settings"];
        })
        (makeDesktopItem {
          name = "davinci-fairlight-studio-utility";
          desktopName = "Fairlight Studio Utility";
          exec = "davinci-fairlight-studio-utility";
          icon = "davinci-resolve${lib.optionalString studioVariant "-studio"}";
          categories = [
            "AudioVideo"
            "Audio"
          ];
        })
      ]
      ++ lib.optional studioVariant (makeDesktopItem {
        name = "davinci-remote-monitor";
        desktopName = "DaVinci Remote Monitor";
        exec = "davinci-remote-monitor";
        icon = "davinci-remote-monitor";
        comment = "DaVinci Remote Monitor";
        categories = [
          "AudioVideo"
          "Video"
        ];
      });
  };
in
  buildFHSEnv {
    inherit (davinci) pname version;

    targetPkgs = pkgs:
      with pkgs; [
        alsa-lib
        aprutil
        bzip2
        davinci
        dbus
        expat
        fontconfig
        freetype
        glib
        krb5
        libdrm
        libGL
        libGLU
        libarchive
        libcap
        libice
        libsm
        librsvg
        libtool
        libuuid
        libx11
        libxcomposite
        libxcursor
        libxdamage
        libxext
        libxfixes
        libxi
        libxinerama
        libxkbcommon
        libxkbfile
        libxcrypt # provides libcrypt.so.1
        libxrandr
        libxrender
        libxt
        libxtst
        libxxf86vm
        libxcb
        libxcb-cursor
        libxcb-image
        libxcb-keysyms
        libxcb-render-util
        libxcb-util
        libxcb-wm
        nspr
        nss
        ocl-icd
        opencl-headers
        python3
        python3.pkgs.numpy
        udev
        xdg-utils # xdg-open needed to open URLs
        xkeyboard_config
        zlib
      ];

    extraPreBwrapCmds = lib.optionalString studioVariant ''
      mkdir -p ~/.local/share/DaVinciResolve/license || exit 1
      mkdir -p ~/.local/share/DaVinciResolve/Extras || exit 1
    '';

    extraBwrapArgs = lib.optionals studioVariant [
      ''--bind "$HOME"/.local/share/DaVinciResolve/license ${davinci}/.license''
      ''--bind "$HOME"/.local/share/DaVinciResolve/Extras ${davinci}/Extras''
    ];

    runScript = "${bash}/bin/bash ${writeText "davinci-wrapper" ''
      export QT_XKB_CONFIG_ROOT="${xkeyboard_config}/share/X11/xkb"
      export QT_PLUGIN_PATH="${davinci}/libs/plugins:$QT_PLUGIN_PATH"
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/usr/lib32:${davinci}/libs
      export QT_QPA_PLATFORM="''${QT_QPA_PLATFORM:-xcb}"

      if [ $# -gt 0 ]; then
        exec "$@"
      else
        exec ${davinci}/bin/resolve
      fi
    ''}";

    extraInstallCommands = let
      execName = "davinci-resolve${lib.optionalString studioVariant "-studio"}";
      mkWrapper = name: bin:
        writeShellScript name ''
          exec "$(dirname "$0")/${execName}" ${bin} "$@"
        '';
      wrappers =
        {
          "blackmagicraw-player" = "${davinci}/BlackmagicRAWPlayer/BlackmagicRAWPlayer";
          "blackmagicraw-speedtest" = "${davinci}/BlackmagicRAWSpeedTest/BlackmagicRAWSpeedTest";
          "davinci-control-panels-setup" = ''"${davinci}/DaVinci Control Panels Setup/DaVinci Control Panels Setup"'';
          "davinci-fairlight-studio-utility" = ''"${davinci}/Fairlight Studio Utility/Fairlight Studio Utility"'';
        }
        // lib.optionalAttrs studioVariant {
          "davinci-remote-monitor" = ''"${davinci}/bin/DaVinci Remote Monitor"'';
        };
    in ''
      mkdir -p $out/share/applications
      ln -s ${davinci}/share/applications/*.desktop $out/share/applications/

      mkdir -p $out/share/icons/hicolor/{128x128,256x256}/apps
      ln -s ${davinci}/graphics/DV_Resolve.png $out/share/icons/hicolor/128x128/apps/davinci-resolve${lib.optionalString studioVariant "-studio"}.png
      ln -s ${davinci}/graphics/DV_Panels.png $out/share/icons/hicolor/128x128/apps/davinci-control-panels-setup.png
      ${lib.optionalString studioVariant ''
        ln -s ${davinci}/graphics/Remote_Monitoring.png $out/share/icons/hicolor/128x128/apps/davinci-remote-monitor.png
      ''}
      ln -s ${davinci}/graphics/blackmagicraw-player_256x256_apps.png $out/share/icons/hicolor/256x256/apps/blackmagicraw-player.png
      ln -s ${davinci}/graphics/blackmagicraw-speedtest_256x256_apps.png $out/share/icons/hicolor/256x256/apps/blackmagicraw-speedtest.png

      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: bin: ''
          ln -s ${mkWrapper name bin} $out/bin/${name}
        '')
        wrappers
      )}

      mkdir -p $out/share/mime/packages
      ln -s ${davinci}/share/resolve.xml $out/share/mime/packages/
      ln -s ${davinci}/share/blackmagicraw.xml $out/share/mime/packages/

      mkdir -p $out/lib/udev/rules.d
      ln -s ${davinci}/lib/udev/rules.d/99-BlackmagicDevices.rules $out/lib/udev/rules.d/
      ln -s ${davinci}/lib/udev/rules.d/99-ResolveKeyboardHID.rules $out/lib/udev/rules.d/
      ln -s ${davinci}/lib/udev/rules.d/99-DavinciPanel.rules $out/lib/udev/rules.d/
    '';

    passthru =
      {
        inherit davinci;
      }
      // lib.optionalAttrs (!studioVariant) {
        updateScript = lib.getExe (writeShellApplication {
          name = "update-davinci-resolve";
          runtimeInputs = [
            curl
            jq
            common-updater-scripts
          ];
          text = ''
            set -o errexit
            drv=pkgs/by-name/da/davinci-resolve/package.nix
            currentVersion=${lib.escapeShellArg davinci.version}
            downloadsJSON="$(curl --fail --silent https://www.blackmagicdesign.com/api/support/us/downloads.json)"

            latestLinuxVersion="$(echo "$downloadsJSON" | jq '[.downloads[] | select(.urls.Linux) | .urls.Linux[] | select(.downloadTitle | test("DaVinci Resolve")) | .downloadTitle]' | grep -oP 'DaVinci Resolve \K\d+\.\d+(\.\d+)?' | sort | tail -n 1)"
            update-source-version davinci-resolve "$latestLinuxVersion" --source-key=davinci.src

            # Since the standard and studio both use the same version we need to reset it before updating studio
            sed -i -e "s/""$latestLinuxVersion""/""$currentVersion""/" "$drv"

            latestStudioLinuxVersion="$(echo "$downloadsJSON" | jq '[.downloads[] | select(.urls.Linux) | .urls.Linux[] | select(.downloadTitle | test("DaVinci Resolve")) | .downloadTitle]' | grep -oP 'DaVinci Resolve Studio \K\d+\.\d+(\.\d+)?' | sort | tail -n 1)"
            update-source-version davinci-resolve-studio "$latestStudioLinuxVersion" --source-key=davinci.src
          '';
        });
      };

    meta = with lib; {
      description = "Professional video editing, color, effects and audio post-processing";
      homepage = "https://www.blackmagicdesign.com/products/davinciresolve";
      license = licenses.unfree;
      maintainers = with maintainers; [
        amarshall
        jshcmpbll
        orivej
        XBagon
      ];
      platforms = ["x86_64-linux"];
      sourceProvenance = with sourceTypes; [binaryNativeCode];
      mainProgram = "davinci-resolve${lib.optionalString studioVariant "-studio"}";
    };
  }
