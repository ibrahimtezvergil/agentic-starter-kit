#!/usr/bin/env bash
set -euo pipefail

BASE_REF="${1:-HEAD~1}"
HEAD_REF="${2:-HEAD}"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "unknown"
  exit 0
fi

DIFF_FILES="$(git diff --name-only "$BASE_REF" "$HEAD_REF" 2>/dev/null || true)"
[[ -z "$DIFF_FILES" ]] && DIFF_FILES="$(git show --name-only --pretty='' "$HEAD_REF" 2>/dev/null || true)"

score=0

# volume
count=$(echo "$DIFF_FILES" | sed '/^$/d' | wc -l | tr -d ' ')
if (( count > 25 )); then score=$((score+3)); elif (( count > 10 )); then score=$((score+2)); elif (( count > 5 )); then score=$((score+1)); fi

# sensitive paths
if echo "$DIFF_FILES" | grep -Eq '(^|/)database/migrations/|\.sql$'; then score=$((score+3)); fi
if echo "$DIFF_FILES" | grep -Eq '(^|/)(auth|security|permissions|polic|middleware)/|(^|/)routes/'; then score=$((score+2)); fi
if echo "$DIFF_FILES" | grep -Eq '(^|/)config/|(^|/)infra/|(^|/)docker|(^|/)k8s|(^|/)\.github/workflows/'; then score=$((score+2)); fi
if echo "$DIFF_FILES" | grep -Eq '(^|/)tests?/'; then score=$((score-1)); fi

if (( score >= 5 )); then
  echo "high"
elif (( score >= 2 )); then
  echo "medium"
else
  echo "low"
fi
