{
  lib,
  stdenv,
  fetchurl,
  nodejs,
  bun,
  python3,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "context-mode";
  version = "1.0.98";

  src = fetchurl {
    url = "https://registry.npmjs.org/${finalAttrs.pname}/-/${finalAttrs.pname}-${finalAttrs.version}.tgz";
    hash = "sha256-vNBXLIIQzC2IchQFRAkkSLjJmrX7MF5U+p1o9pkCrw0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/${finalAttrs.pname}
    cp -r . $out/lib/${finalAttrs.pname}

    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/${finalAttrs.pname} \
      --add-flags "$out/lib/${finalAttrs.pname}/cli.bundle.mjs" \
      --prefix PATH : ${
        lib.makeBinPath [
          bun
          python3
        ]
      }

    runHook postInstall
  '';

  meta = {
    description = "MCP plugin that saves 98% of your context window";
    homepage = "https://github.com/mksglu/context-mode";
    license = lib.licenses.elastic20;
    maintainers = [ "ReStranger" ];
    platforms = lib.platforms.all;
    mainProgram = finalAttrs.pname;
  };
})
