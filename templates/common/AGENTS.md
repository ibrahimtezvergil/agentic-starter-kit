# AGENTS.md

## Context Hygiene (Mandatory)

Default policy: keep context lean. Do not read/search these paths unless explicitly requested:

- node_modules/, vendor/, .git/
- dist/, build/, out/, .next/, .nuxt/, coverage/
- storage/logs/, logs/, tmp/, temp/
- large binaries/artifacts

### Allowed-first workflow
1. Work only in explicitly allowed paths (e.g. app/, resources/, tests/).
2. If additional paths are needed, ask first and justify briefly.
3. Never dump full logs/test output; return only failure summary + relevant stack.

### Search commands must exclude heavy paths
Use ripgrep with globs:
`rg "<pattern>" . --glob '!node_modules/**' --glob '!vendor/**' --glob '!.git/**' --glob '!dist/**' --glob '!build/**' --glob '!storage/logs/**'`

### Exception rule
Access ignored paths only when task explicitly requires it (targeted file/command, minimal output).
