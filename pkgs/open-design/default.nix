{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs_22,
  pnpm_10,
  pnpmConfigHook,
  makeWrapper,
  python3,
  pkg-config,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: let
  workspaceDirs = [
    "packages/release"
    "packages/contracts"
    "packages/registry-protocol"
    "packages/agui-adapter"
    "packages/plugin-runtime"
    "packages/sidecar-proto"
    "packages/launcher-proto"
    "packages/platform"
    "packages/sidecar"
    "packages/diagnostics"
    "packages/components"
    "packages/host"
    "packages/download"
    "apps/daemon"
    "apps/web"
  ];

  # Brace glob => topological build order; workspace packages need each
  # other's dist/*.d.ts (sidecar -> platform, contracts -> release).
  packageFilter = "./packages/{${
    lib.concatStringsSep "," (map (ws: lib.last (lib.splitString "/" ws))
      (lib.filter (ws: lib.hasPrefix "packages/" ws) workspaceDirs))
  }}";

  # apps/web ships as a static export only; its build deps are not runtime.
  runtimeWorkspaceDirs = builtins.filter (ws: ws != "apps/web") workspaceDirs;
  runtimeWorkspaceFilter = lib.concatMapStringsSep " " (ws: "--filter ./${ws}")
    runtimeWorkspaceDirs;
in {
  pname = "open-design";
  version = "0.24.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nexu-io";
    repo = "open-design";
    rev = "open-design-v${finalAttrs.version}";
    hash = "sha256-CJpr0JIww5XGgPqTDwaQlPBCB0Kz5GtOCOyKMfT9zyA=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    pnpmWorkspaces = map (ws: "./${ws}") workspaceDirs;
    hash = "sha256-s5ZUgT3xWYNUa3kKwgBNiLMowc20AyxsUe5zjqJGQLo=";
  };

  pnpmWorkspaces = map (ws: "./${ws}") workspaceDirs;

  nativeBuildInputs = [
    nodejs_22
    pnpm_10
    pnpmConfigHook
    makeWrapper
    python3
    pkg-config
  ];

  env = {
    NODE_ENV = "production";
    OD_DAEMON_URL = "";
  };

  buildPhase = ''
    runHook preBuild

    export npm_config_nodedir=${nodejs_22}
    export npm_config_build_from_source=true
    export PATH="${nodejs_22}/lib/node_modules/npm/bin/node-gyp-bin:$PATH"

    # fetchPnpmDeps installs with --ignore-scripts, so the addon needs a build.
    bsq_dir=$(find node_modules/.pnpm -mindepth 2 -maxdepth 4 -type d \
      -path '*/better-sqlite3@*/node_modules/better-sqlite3' -print -quit)
    if [ ! -f "$bsq_dir/build/Release/better_sqlite3.node" ]; then
      echo "Building better-sqlite3 at $bsq_dir"
      ( cd "$bsq_dir" && node-gyp rebuild --release --build-from-source )
    fi
    test -f "$bsq_dir/build/Release/better_sqlite3.node"

    pnpm --filter '${packageFilter}' run --if-present build

    echo "Building @open-design/daemon"
    pnpm -C apps/daemon run build

    echo "Building @open-design/web (static export)"
    pnpm --filter @open-design/web run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/open-design $out/bin

    # Ship a prod-only tree: the build-time install is ~1.9G of compilers,
    # bundlers and test tooling `od` never loads. `--prod` over the existing
    # tree is a no-op (pnpm trusts node_modules/.modules.yaml), so wipe it to
    # force a real resolve -- offline, from pnpm-lock.yaml.
    find . -mindepth 1 -maxdepth 4 -type d -name node_modules -prune \
      -exec rm -rf {} +
    pnpm install ${runtimeWorkspaceFilter} --prod --offline --ignore-scripts \
      --config.confirmModulesPurge=false

    # --prod relinks from the store with --ignore-scripts, dropping the addon.
    export npm_config_nodedir=${nodejs_22}
    export npm_config_build_from_source=true
    export PATH="${nodejs_22}/lib/node_modules/npm/bin/node-gyp-bin:$PATH"
    bsq_dir=$(find node_modules/.pnpm -mindepth 2 -maxdepth 4 -type d \
      -path '*/better-sqlite3@*/node_modules/better-sqlite3' -print -quit)
    if [ ! -f "$bsq_dir/build/Release/better_sqlite3.node" ]; then
      echo "Rebuilding better-sqlite3 at $bsq_dir"
      ( cd "$bsq_dir" && node-gyp rebuild --release --build-from-source )
    fi
    test -f "$bsq_dir/build/Release/better_sqlite3.node"

    cp -r . $out/lib/open-design/

    for ws in ${lib.concatStringsSep " " workspaceDirs}; do
      if [ -d "$out/lib/open-design/$ws" ]; then
        if [ "$ws" = "apps/web" ]; then
          find "$out/lib/open-design/$ws" -mindepth 1 -maxdepth 1 \
            ! -name out \
            ! -name dist \
            ! -name node_modules \
            ! -name package.json \
            ! -name next.config.ts \
            -exec rm -rf {} +
        elif [ "$ws" = "apps/daemon" ]; then
          find "$out/lib/open-design/$ws" -mindepth 1 -maxdepth 1 \
            ! -name dist \
            ! -name bin \
            ! -name node_modules \
            ! -name package.json \
            -exec rm -rf {} +
        else
          find "$out/lib/open-design/$ws" -mindepth 1 -maxdepth 1 \
            ! -name dist \
            ! -name node_modules \
            ! -name package.json \
            -exec rm -rf {} +
        fi
      fi
    done

    # PROJECT_ROOT = <apps/daemon>/../..; these are the only top-level
    # entries it reads (apps/daemon/dist/server.js:370-422).
    find "$out/lib/open-design" -mindepth 1 -maxdepth 1 \
      ! -name node_modules \
      ! -name apps \
      ! -name packages \
      ! -name assets \
      ! -name craft \
      ! -name data \
      ! -name design-systems \
      ! -name design-templates \
      ! -name plugins \
      ! -name prompt-templates \
      ! -name skills \
      ! -name package.json \
      -exec rm -rf {} +

    # apps/ keeps daemon (the CLI entrypoint) and web/out (the static export).
    find "$out/lib/open-design/apps" -mindepth 1 -maxdepth 1 \
      ! -name web ! -name daemon -exec rm -rf {} +
    find "$out/lib/open-design/apps/web" -mindepth 1 -maxdepth 1 ! -name out \
      -exec rm -rf {} +

    chmod +x $out/lib/open-design/apps/daemon/dist/cli.js

    # Fail the build, not the user: the pruning above is hand-maintained.
    for required in \
      "$out/lib/open-design/package.json" \
      "$out/lib/open-design/node_modules" \
      "$out/lib/open-design/apps/daemon/package.json" \
      "$out/lib/open-design/apps/daemon/dist/cli.js" \
      "$out/lib/open-design/apps/web/out" ; do
      if [ ! -e "$required" ]; then
        echo "ERROR: missing runtime path in \$out: $required" >&2
        exit 1
      fi
    done
    makeWrapper ${lib.getExe nodejs_22} $out/bin/od \
      --add-flags $out/lib/open-design/apps/daemon/dist/cli.js \
      --set NODE_ENV production \
      --run 'if [ -z "$OD_DATA_DIR" ]; then export OD_DATA_DIR="$HOME/.od"; fi'
    ln -s $out/bin/od $out/bin/open-design

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--version-regex"
      "open-design-v(\\d+\\.\\d+\\.\\d+)"
    ];
  };

  meta = with lib; {
    description = "Local-first design product — daemon (`od` CLI) + Next.js frontend for agent-native design artifacts";
    longDescription = ''
      OpenDesign is an open-source Claude Design alternative: a local-first
      app that detects installed coding-agent CLIs (Claude Code, Codex,
      Cursor, etc.), runs functional skills and design-system contracts,
      and streams artifacts (prototypes, decks, dashboards, images,
      HyperFrames video) into a sandboxed preview. The `od` CLI starts
      the local Express + SQLite daemon that powers the web UI and MCP
      server. This package builds both the daemon and the static web
      export (apps/web/out) so `od` can serve the UI without an external
      reverse proxy.
    '';
    homepage = "https://github.com/nexu-io/open-design";
    downloadPage = "https://github.com/nexu-io/open-design/releases";
    changelog = "https://github.com/nexu-io/open-design/blob/main/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ReStranger];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "od";
  };
})
