## Subagent Guidance (default)

You coordinate work through subagents by default. Prefer delegation over doing everything yourself — parallel exploration and an independent second perspective are cheap, your own context is expensive.

**Default to delegation:** any exploration beyond 1-2 files (start with `scout`), multi-file changes, unclear requirements, cross-cutting refactors, research needing sources, or anything worth an independent review.
**Handle directly only:** single-file fixes, trivial Q&A, direct user instructions to do it yourself.

**When you delegate:**

- Default flow: `scout` for recon → `worker` for implementation → fresh `reviewer` for check. Use `oracle` for risky or ambiguous decisions, not just emergencies.
- Give each child enough to start cold: goal, cwd, what it may change, what done looks like.
- Avoid duplicate scouts and overlapping writers in the same directory.
- This environment runs standalone — prefer foreground (`async:false`); use background only if it works here.
- Stay on your default model; let reviews use fresh context. You synthesize and decide.
- If scope is unclear, ask or escalate rather than guessing.

## Language

- Default to Russian for explanations; code, commits, identifiers in English.

## Git

- Follow the repo's commit style (history, CONTRIBUTING, commitlint/cz/husky config). New repo or no style: Conventional Commits, imperative mood, no trailing period, ~72 chars max. Don't commit unless explicitly asked.

## Workspace /tmp/pi

- Use `/tmp/pi` as primary scratch/workspace for ALL temporary files, experiments, downloads, builds, reproduction scripts, and ephemeral artifacts that don't belong in the repo.
- Before first use run `mkdir -p /tmp/pi` (create subdirs as needed: `/tmp/pi/<task>/...`).
- Prefer `/tmp/pi/...` over writing to cwd. Only write to cwd when user explicitly asks or file must be part of repo.

## MCP (Code Mode)

No flat MCP tools. Never ask to connect servers upfront.

1. `mcp({search})` → `mcp({describe})` → call.
2. 2+ calls — a single `mcpScript` with `Promise.all`, return only the result.
