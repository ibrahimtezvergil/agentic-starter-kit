---
name: bugfix-safe
description: Safely fix a reproducible bug with scoped edits and mandatory validation. Use for bug fixes, regressions, and failing tests.
disable-model-invocation: true
argument-hint: "[bug description | issue id]"
allowed-tools: Read, Grep, Glob, Edit, MultiEdit, Write, Bash(git *), Bash(php artisan *), Bash(composer *), Bash(npm *), Bash(pnpm *), Bash(yarn *)
---

Fix this bug safely: $ARGUMENTS

Follow this exact flow:

1) Scope
- Restrict edits to app/, routes/, resources/, config/, database/, tests/ unless user expands scope.
- Do not inspect node_modules/, vendor/, .git/, dist/, build/, storage/logs/ unless explicitly needed.

2) Reproduce
- Identify a reproducible path (existing failing test/log/command).
- If not reproducible, ask one concise clarification question.

3) Plan
- List likely root cause and files to touch.
- Prefer smallest safe change over broad refactor.

4) Implement
- Make minimal edits.
- Preserve existing architecture/patterns.

5) Validate (mandatory)
- Run relevant tests/lint/build commands.
- If tests fail, fix and rerun.

6) Output format
- Root cause
- Changed files
- Validation commands + results
- Risks/edge cases
- Next step
