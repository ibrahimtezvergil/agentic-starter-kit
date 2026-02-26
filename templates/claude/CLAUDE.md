# CLAUDE.md

## Working style
- Explore first, then plan, then implement.
- Keep changes small and verifiable.
- Always run validation commands before finishing.

## Context discipline
- Prefer allowed paths only.
- Avoid large/generated folders unless explicitly required.

## Default validation
- Run project tests/lint/build commands relevant to the task.
- Return concise summary: changed files, test output, risks.

## Safety
- Ask before destructive operations.
- Avoid external actions unless explicitly requested.
