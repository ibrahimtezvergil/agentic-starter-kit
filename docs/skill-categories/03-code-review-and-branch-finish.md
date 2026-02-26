# Category 3 — Code Review + Branch Finish

## Objective
Move from "works" to "merge-ready" with consistent quality gates.

## Canonical Core Skills
- requesting-code-review
- receiving-code-review
- finishing-a-development-branch

## Mandatory Flow
`requesting-code-review -> receiving-code-review -> finishing-a-development-branch`

## Review Standard
Every review output should include:
- Severity: Critical / Important / Minor
- File/area
- Why it matters
- Minimal fix guidance
- Merge-blocking status

## Merge Gates
Must be true before merge/PR:
1. Test/lint/build verified
2. No unresolved Critical findings
3. Important findings resolved or explicitly deferred
4. Requirement/plan alignment confirmed
5. Branch finish workflow completed

## Branch Finish Policy
- Keep 4-option completion menu (merge / PR / keep / discard)
- Require typed confirmation for discard
- Re-test after local merge
- PR mode defaults to keeping branch/worktree unless user asks cleanup

## Patch Notes
- Standardize severity rubric
- Enforce re-review after important fixes
- Clarify cleanup behavior in PR flow
