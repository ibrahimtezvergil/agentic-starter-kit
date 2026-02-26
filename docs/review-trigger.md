# Review Trigger Flow (Semi-Automatic)

## Goal
Trigger review in a controlled way without full automation spam.

## Behavior
1. After each commit, a `post-commit` hook asks:
   - `Start review now? (y/N)`
2. If `y`, it asks for a task slug and runs:
   - `scripts/ready-review.sh <task-slug>`
3. That script generates a review request file in:
   - `docs/review-queue/<timestamp>-<task-slug>-review-request.md`
4. On push, `pre-push` runs migration safety gate for migration/sql changes.

You can then send that file content to Claude Code (or another reviewer agent).

## Why this is safe
- No forced automatic review
- No review spam for every WIP commit
- User-test can happen before saying `y`

## Setup
From project root:

```bash
scripts/install-git-hooks.sh
```

## Manual fallback
If you skip in post-commit prompt:

```bash
scripts/ready-review.sh <task-slug>
```
