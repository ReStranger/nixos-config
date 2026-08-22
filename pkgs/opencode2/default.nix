{
  common-updater-scripts,
  curl,
  jq,
  lib,
  stdenvNoCC,
  fetchurl,
  writeShellApplication,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencode2";
  version = "0.0.0-beta-17498";

  src =
    fetchurl
    {
      x86_64-linux = {
        url = "https://registry.npmjs.org/@opencode-ai/cli-linux-x64/-/cli-linux-x64-${finalAttrs.version}.tgz";
        hash = "sha256-/pNmOn+pIChsL/fWJfdNEo8B9U66sFSbXlpkj1m3TOw=";
      };
      aarch64-linux = {
        url = "https://registry.npmjs.org/@opencode-ai/cli-linux-arm64/-/cli-linux-arm64-${finalAttrs.version}.tgz";
        hash = "sha256-ZW4v4bRl7TO3r7y5Z/6WjIc8w3oX62GiBzf+3LT2L7M=";
      };
      x86_64-darwin = {
        url = "https://registry.npmjs.org/@opencode-ai/cli-darwin-x64/-/cli-darwin-x64-${finalAttrs.version}.tgz";
        hash = "sha256-ox6hR8mO4jcOg4mEQjBCUdrLj7xqlnKEI7pJ4gJaU8U=";
      };
      aarch64-darwin = {
        url = "https://registry.npmjs.org/@opencode-ai/cli-darwin-arm64/-/cli-darwin-arm64-${finalAttrs.version}.tgz";
        hash = "sha256-YHcJm5FrASc7r39DMe0Wt7WZ7pATIkVx2VS5hHL83WI=";
      };
    }
    .${
      stdenvNoCC.hostPlatform.system
    };

  sourceRoot = "package";

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/opencode2 $out/bin/opencode2
    chmod +x $out/bin/opencode2

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "update-opencode2";
    runtimeInputs = [
      common-updater-scripts
      curl
      jq
    ];
    text = builtins.readFile ./update.sh;
  });

  meta = {
    description = "OpenCode AI CLI (next channel)";
    homepage = "https://github.com/anomalyco/opencode";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ReStranger];
    platforms = lib.platforms.all;
    mainProgram = finalAttrs.pname;
    sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
  };
})
