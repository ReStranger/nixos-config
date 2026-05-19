{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "doro-cursor";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "ReStranger";
    repo = "doro-cursor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uwQ7SsxJZlBApFqWdUXn/CnONwWZomcKhSVspaLCqNo=";
  };
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -dm 0755 $out/share/icons/Doro
    cp -r cursors index.theme $out/share/icons/Doro/

    runHook postInstall
  '';

  meta = {
    description = "Doro cursor theme";
    homepage = "https://www.gnome-look.org/p/2303805";
    license = lib.licenses.unfreeRedistributable;
    platforms = lib.platforms.linux;
  };
})
