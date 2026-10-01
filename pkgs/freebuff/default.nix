{
  lib,
  buildNpmPackage,
  fetchzip,
  nodejs,
  nix-update,
  writeShellApplication,
}:
buildNpmPackage (finalAttrs: {
  pname = "freebuff";
  version = "0.2.11";

  src = fetchzip {
    url = "https://registry.npmjs.org/freebuff/-/freebuff-${finalAttrs.version}.tgz";
    hash = "sha256-VDMj5EZJEGr+PTMSAxqWklZ8IizYxYVLkTI4k1PlrIU=";
  };

  strictDeps = true;

  npmDepsHash = "sha256-tBC+dz/JNNpe/oJ76/e545+ysv4lHqb0CUQL+lZZ81g=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  # `npm pack --dry-run` (used by the install hook to enumerate files)
  # runs the package's `prepack` script, which references
  # ../../../cli/release-core/prepare-package.js — absent from the published
  # tarball. The tarball already contains the generated files, so skip it.
  npmPackFlags = ["--ignore-scripts"];

  passthru.updateScript = writeShellApplication {
    name = "update-freebuff";
    runtimeInputs = [
      nodejs
      nix-update
    ];
    text = ''
      version=$(npm view freebuff version)
      echo "freebuff: $version"

      (
        cd pkgs/freebuff
        npm install --package-lock-only "freebuff@$version" --ignore-scripts
        rm -f package.json
      )

      nix-update --flake freebuff --version "$version"
    '';
  };

  meta = {
    description = "The world's strongest free coding agent";
    homepage = "https://freebuff.com/";
    downloadPage = "https://www.npmjs.com/package/freebuff";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ReStranger];
    mainProgram = "freebuff";
  };
})
