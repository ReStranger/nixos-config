### Repository Tools

Prefer Pi tools:

* `find` — file discovery
* `grep` — content search
* `read` — reading
* `edit` — modifying files
* `write` — creating files
* `bash` — real shell/system commands

Do not use shell `find`, `fd`, `grep`, or `rg` for repository exploration.

Do not use `cat`, `head`, `tail`, `sed`, `awk`, or heredocs when the equivalent
Pi tool is available.

Use `bash` for builds, tests, package managers, process control, system
commands, and other operations that actually require a shell.

### Pi Code Mode

Use Pi Code Mode when programmatic composition of normal Pi tools is more
efficient than repeated direct calls.

Do not use it merely because scripting is possible.

### MCP

Current MCP configuration:

```
directTools = false
scriptMode = true
```

Therefore MCP tools are accessed through the MCP proxy rather than as normal
direct tools.

Use:

* `mcp` — search, describe, status, auth, and single MCP calls
* `mcpScript` — multi-step MCP workflows

Typical discovery:

```
search → describe → call
```

Use `mcpScript` for:

* dependent call chains
* loops
* filtering
* aggregation
* fan-out
* conditional workflows

Use `Promise.all` only for genuinely independent calls.

Do not guess unknown MCP schemas when discovery is available.

Do not repeatedly search for a tool whose exact path is already known.

A disabled MCP server is unavailable. The current `web-search` server is
disabled.

### Workspace

The repository is the default working directory.

Use `/tmp/pi/<task>/` only for genuinely temporary artifacts.

### Language

Default to Russian for explanations.

Use English for code, identifiers, commands, commits, and technical names.
