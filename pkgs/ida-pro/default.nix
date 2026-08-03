{
  autoPatchelfHook,
  cairo,
  dbus,
  fontconfig,
  freetype,
  glib,
  gtk3,
  lib,
  libdrm,
  libGL,
  libkrb5,
  libsecret,
  libunwind,
  libxkbcommon,
  makeWrapper,
  openssl,
  perl,
  python313,
  stdenv,
  libxcb-wm,
  libxcb-render-util,
  libxcb-keysyms,
  libxcb-image,
  libxcb-cursor,
  libxrender,
  libxi,
  libxext,
  libxau,
  libx11,
  libxcrypt-legacy,
  qt6,
  libsm,
  libice,
  libxcb,
  zlib,
  requireFile,
  hexPatches ? [],
  # hexPatches: hex patterns to substitute in specified files immediately after
  # install. Can be used, for example, to replace the embedded SSL certificates
  # for compatibility with a self-hosted Lumina server.
  # Since IDA is distributed as a binary, such patching is the only recourse
  # available to us for interoperability purposes.
}: let
  pythonForIDA = python313.withPackages (ps: with ps; [rpyc]);

  # Callers can supply their own binary substitutions via `hexPatches`.
  patchScript =
    lib.concatMapStringsSep "\n" (
      p: let
        forcecntDecl = lib.optionalString (p ? assertCount) "my $forcecnt = ${toString p.assertCount};";
      in ''
        if [ -f "$IDADIR/${p.filename}" ]; then
          ${lib.getExe perl} -0777 -pi -e '${forcecntDecl} my $cnt = (s/\Q''${\pack("H*","${p.from}")}\E/''${\pack("H*","${p.to}")}/g) || 0; die "Expected $forcecnt substitutions, did $cnt\n" if defined $forcecnt && $cnt != $forcecnt' "$IDADIR/${p.filename}"
        fi
      ''
    )
    hexPatches;
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "ida-pro";
    version = "9.3.260421";

    src = requireFile {
      name = "ida-pro_93_x64linux.run";
      url = "https://my.hex-rays.com/";
      hash = "sha256-pk5lif7soPThv7li0aKDdh+zjFFY9fgsjx593zL2mFA=";
    };

    nativeBuildInputs = [
      makeWrapper
      autoPatchelfHook
      perl
    ];

    # We just get a runfile in $src, so no need to unpack it.
    dontUnpack = true;

    # Add everything to the RPATH, in case IDA decides to dlopen things.
    runtimeDependencies = [
      cairo
      dbus
      fontconfig
      freetype
      glib
      gtk3
      libdrm
      libGL
      libkrb5
      libsecret
      qt6.qtbase
      qt6.qtwayland
      libunwind
      libxkbcommon
      openssl
      stdenv.cc.cc
      libice
      libsm
      libx11
      libxcrypt-legacy
      libxau
      libxcb
      libxext
      libxi
      libxrender
      libxcb-image
      libxcb-keysyms
      libxcb-render-util
      libxcb-wm
      libxcb-cursor
      pythonForIDA
      zlib
    ];
    buildInputs = finalAttrs.runtimeDependencies;

    dontWrapQtApps = true;

    # IDA comes with its own Qt6, some dependencies are missing in the installer.
    autoPatchelfIgnoreMissingDeps = [
      "libQt6Network.so.6"
      "libQt6EglFSDeviceIntegration.so.6"
      "libQt6WaylandEglClientHwIntegration.so.6"
      "libQt6WaylandCompositor.so.6"
      "libQt6WlShellIntegration.so.6"
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/lib $out/opt
      mkdir -p $out/.local/share/applications

      # IDA depends on quite some things extracted by the runfile, so first extract everything
      # into $out/opt, then remove the unnecessary files and directories.
      IDADIR=$out/opt/${finalAttrs.pname}-${finalAttrs.version}

      # The installer doesn't honor `--prefix` in all places,
      # thus needing to set `HOME` here.
      HOME=$out

      # Invoke the installer with the dynamic loader directly, avoiding the need
      # to copy it to fix permissions and patch the executable.
      $(cat $NIX_CC/nix-support/dynamic-linker) $src \
        --mode unattended --debuglevel 4 --prefix $IDADIR

      ${patchScript}

      # Copy the exported libraries to the output.
      cp $IDADIR/libida.so $out/lib

      # Some libraries come with the installer.
      addAutoPatchelfSearchPath $IDADIR

      # Link the binaries to the output.
      # Also, hack the PATH so that pythonForIDA is used over the system python.
      wrapProgram $IDADIR/ida \
        --prefix IDADIR : $IDADIR \
        --prefix QT_PLUGIN_PATH : $IDADIR/plugins/platforms \
        --prefix PYTHONPATH : $out/bin/idalib/python \
        --prefix PATH : ${pythonForIDA}/bin:$IDADIR \
        --prefix LD_LIBRARY_PATH : $IDADIR
      ln -s $IDADIR/ida $out/bin/ida

      # runtimeDependencies don't get added to non-executables, and these are needed
      # by the exported libida used by the Pro package.
      patchelf --add-needed libcrypto.so $IDADIR/libida.so
      patchelf --add-needed libpython3.13.so $out/lib/libida.so
      patchelf --add-needed libsecret-1.so.0 $out/lib/libida.so

      mv $out/.local/share $out
      rm -r $out/.local

      runHook postInstall
    '';

    meta = {
      description = "The world's smartest and most feature-full disassembler";
      homepage = "https://hex-rays.com/ida-pro/";
      changelog = "https://hex-rays.com/products/ida/news/";
      license = lib.licenses.unfree;
      mainProgram = "ida";
      maintainers = with lib.maintainers; [ReStranger];
      platforms = ["x86_64-linux"]; # Right now, the installation script only supports Linux.
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
    };
  })
