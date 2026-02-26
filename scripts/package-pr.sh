#!/usr/bin/env bash
set -euo pipefail

TASK_SLUG="${1:-}"
BASE_REF="${2:-origin/main}"
HEAD_REF="${3:-HEAD}"
DATE="$(date +%F)"
OUT_DIR="docs/pr-packages"
mkdir -p "$OUT_DIR"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "❌ Not inside a git repository"
  exit 1
fi

BRANCH="$(git branch --show-current)"
HEAD_SHA="$(git rev-parse --short "$HEAD_REF")"
RISK="$(scripts/analyze-risk.sh "$BASE_REF" "$HEAD_REF" 2>/dev/null || echo unknown)"

PLAN_HINT=""
if [[ -n "$TASK_SLUG" && -f "docs/plans/${DATE}-${TASK_SLUG}.md" ]]; then
  PLAN_HINT="docs/plans/${DATE}-${TASK_SLUG}.md"
fi

OUT_FILE="$OUT_DIR/${DATE}-${TASK_SLUG:-$BRANCH}-pr-package.md"

cat > "$OUT_FILE" <<EOF
# PR Package

- Branch: ${BRANCH}
- Head: ${HEAD_SHA}
- Base: ${BASE_REF}
- Auto risk: ${RISK}
- Plan: ${PLAN_HINT:-"(not resolved automatically)"}

## Summary
- [Fill] What changed?
- [Fill] Why this change?

## Changed Files
$(git diff --name-only "$BASE_REF" "$HEAD_REF" | sed '/^$/d' | sed 's/^/- /' || true)

## Validation
- [Fill] test command + result
- [Fill] lint command + result
- [Fill] build command + result

## Reviewer Focus
1. Security
2. Correctness
3. Race/concurrency
4. Test quality
5. Maintainability

## Rollback
- [Fill] rollback strategy
EOF

echo "✅ PR package created: $OUT_FILE"
