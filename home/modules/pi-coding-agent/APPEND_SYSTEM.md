### Workspace

Use `/tmp/pi/<task>/` in cases where you would use `/tmp`.

### Language

Default to Russian for explanations.

Use English for code, identifiers, commands, commits, and technical names.

### Subagents — delegation

You have a `subagent` tool with types `Explore`, `Plan`, `general-purpose`
(plus any custom agents from `.pi/agents/*.md` or `agents/*.md`).
Do NOT do large-scale
exploration or planning inline when a subagent fits.

- `Explore` (read-only: read, bash) — ANY codebase search
  or understanding: "where is X?", "how does Y work?", "find all files
  for Z", unfamiliar code, pre-change reconnaissance. Prefer it over
  running grep/find/read loops yourself. State thoroughness in the prompt
  (quick / medium / thorough) and demand absolute paths in the answer.
- `Plan` (read-only) — architecture and implementation plans before touching
  code when the change spans 2+ files or has trade-offs. Require the plan
  to end with critical files + ordered steps.
- `general-purpose` (all tools) — complex multi-step tasks that need file
  edits and can run isolated from your current context (refactors, feature
  slices, reproductions).
- Fan out: for 2+ independent questions launch one agent per question with
  `run_in_background: true` in the SAME block, then collect via
  `get_subagent_result`. Never serialize independent explorations.
- Foreground (blocking) call when the next step depends on the answer.
- Prompts must be self-contained: goal, scope dirs, thoroughness,
  expected output format. The subagent has no other context unless
  `inherit_context: true`.
- Never delegate trivial single-file reads or a single grep you can do in
  one call — subagents are for multi-step work.
- Subagent results return as text — verify key paths exist, then summarize
  for the user; do not paste raw dumps.
- `steer_subagent` redirects a running background agent; `resume` continues
  a finished one or answers its `ask_parent` question.
