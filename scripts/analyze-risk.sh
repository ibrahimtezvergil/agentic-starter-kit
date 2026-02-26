#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=scripts/lib-config.sh
source "$(dirname "$0")/lib-config.sh"

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
high_fc="$(config_get risk.high_file_count 25)"
med_fc="$(config_get risk.medium_file_count 10)"
if (( count > high_fc )); then score=$((score+3)); elif (( count > med_fc )); then score=$((score+2)); elif (( count > 5 )); then score=$((score+1)); fi

# sensitive paths
if echo "$DIFF_FILES" | grep -Eq '(^|/)database/migrations/|\.sql$'; then score=$((score+3)); fi
if echo "$DIFF_FILES" | grep -Eq '(^|/)(auth|security|permissions|polic|middleware)/|(^|/)routes/'; then score=$((score+2)); fi
if echo "$DIFF_FILES" | grep -Eq '(^|/)config/|(^|/)infra/|(^|/)docker|(^|/)k8s|(^|/)\.github/workflows/'; then score=$((score+2)); fi
if echo "$DIFF_FILES" | grep -Eq '(^|/)tests?/'; then score=$((score-1)); fi

high_th="$(config_get risk.high_score_threshold 5)"
med_th="$(config_get risk.medium_score_threshold 2)"
if (( score >= high_th )); then
  echo "high"
elif (( score >= med_th )); then
  echo "medium"
else
  echo "low"
fi
