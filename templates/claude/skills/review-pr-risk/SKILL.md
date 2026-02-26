---
name: review-pr-risk
description: Review a PR/branch for high-priority risks (security, bugs, race conditions, maintainability, test gaps) and return actionable findings.
disable-model-invocation: true
argument-hint: "[PR number | branch name | compare target]"
context: fork
allowed-tools: Read, Grep, Glob, Bash(git *), Bash(gh *), Bash(php artisan *), Bash(composer *), Bash(npm *), Bash(pnpm *), Bash(yarn *)
---

Review target: $ARGUMENTS

Perform a risk-first review with this checklist:

1) Security
- Auth/authz issues, injection risks, sensitive data exposure, unsafe defaults.

2) Correctness/Bugs
- Logic regressions, null/edge handling, error-path behavior.

3) Concurrency/Race
- Shared state, transaction boundaries, async ordering risks.

4) Test quality
- Missing coverage for changed behavior, flaky patterns, brittle assertions.

5) Maintainability
- Over-complex diffs, hidden coupling, naming/readability concerns.

Output strict format:
- Summary risk score: Low/Medium/High
- Findings (prioritized):
  - [Severity] [Category] [File/Area]
  - Why it matters
  - How to reproduce (if applicable)
  - Minimal fix suggestion
- Quick wins
- Merge recommendation: Approve / Request changes

Constraints:
- Do not modify files.
- Keep feedback concrete and diff-aware; avoid generic advice.
