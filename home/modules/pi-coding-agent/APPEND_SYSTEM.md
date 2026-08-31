## Running tools

- Always prefer `rg` (ripgrep) over `grep` and `fd` over `find` when using bash. Never use `grep`/`find` shell commands — use `rg`/`fd` via `bash` tool instead.
- If a command is missing, run it ephemerally via Nix — never install it.
- One-off: `nix run nixpkgs#<package> -- <args>`
- Shell + cmds: `nix shell nixpkgs#<p1> [nixpkgs#<p2>...] -c <cmd> [args...]`
- Repo flakes: prefer `nix develop -c <cmd> ...` over hand-built shells.
- STRICTLY FORBIDDEN: `nix-env -iA nixos.<pkg>`, `nix profile install`, `npm i -g`, `pip install --user`, and any other global/user installs. If a tool seems to require a persistent install, stop and tell the user to add it to their NixOS/Home Manager config instead.
- Use exact attribute paths when the package name is ambiguous (e.g. `nixpkgs#nil` vs editor packages).
- If the package does not exist in nixpkgs, report it rather than looking for workarounds.

## Workspace /tmp/pi

- Use `/tmp/pi` as primary scratch/workspace for ALL temporary files, experiments, downloads, builds, reproduction scripts, and ephemeral artifacts that don't belong in the repo.
- Before first use run `mkdir -p /tmp/pi` (create subdirs as needed: `/tmp/pi/<task>/...`).
- Prefer `/tmp/pi/...` over writing to cwd. Only write to cwd when user explicitly asks or file must be part of repo.
- `/tmp/pi` is already whitelisted in `pi-cwd-guard` (`allowedOutsideCwdPaths`), no permission prompt needed — use it.
