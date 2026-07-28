#!/usr/bin/env bash
set -euo pipefail

pkg=opencode2
file=pkgs/opencode2/default.nix

latestVersion="$(
  curl --fail --silent https://registry.npmjs.org/@opencode-ai/cli-linux-x64 \
    | jq -er '.["dist-tags"].next'
)"

nix-update "$pkg" \
  --version=skip \
  --override-filename "$file" \
  --source-key src.x86_64-linux

for sourceKey in \
  src.aarch64-linux \
  src.x86_64-darwin \
  src.aarch64-darwin
do
  update-source-version "$pkg" "$latestVersion" \
    --ignore-same-version \
    --source-key="$sourceKey"
done
