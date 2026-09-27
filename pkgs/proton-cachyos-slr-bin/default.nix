{
  lib,
  fetchzip,
  nix-update-script,
  proton-ge-bin,
  steamDisplayName ? "Proton CachyOS SLR",
}:
proton-ge-bin.overrideAttrs (
  finalAttrs: prevAttrs: {
    strictDeps = true;
    __structuredAttrs = true;

    inherit steamDisplayName;

    pname = "proton-cachyos-slr-bin";
    version = "cachyos-11.0-20260703-slr";

    src = fetchzip {
      url = "https://github.com/CachyOS/proton-cachyos/releases/download/${finalAttrs.version}/proton-${finalAttrs.version}-x86_64.tar.xz";
      hash = "sha256-jOcPeEkBBPPNqyjXBoHm1Nk8AexPiLhx5+385NjUPT0=";
    };

    preFixup = ''
      substituteInPlace "$steamcompattool/compatibilitytool.vdf" \
        --replace-fail "proton-${finalAttrs.version}-x86_64" "${steamDisplayName}"
    '';

    passthru =
      prevAttrs.passthru
      // {
        updateScript = nix-update-script {
          extraArgs = [
            "--flake"
            "--version-regex"
            "(.*-slr)"
          ];
        };
      };

    meta = {
      description = ''
        Compatibility tool for Steam Play based on Wine and additional components.
        This version is build against the Steam Linux Runtime (SLR).

        (This is intended for use in the `programs.steam.extraCompatPackages` option only.)
      '';
      homepage = "https://github.com/CachyOS/proton-cachyos";
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [ReStranger];
      platforms = ["x86_64-linux"];
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    };
  }
)
