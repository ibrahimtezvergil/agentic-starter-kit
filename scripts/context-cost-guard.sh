#!/usr/bin/env bash
set -euo pipefail

PLAN_FILE="${1:-}"
WARN=0

echo "🧮 Context/Cost Guard"

if [[ -n "$PLAN_FILE" && -f "$PLAN_FILE" ]]; then
  lines=$(wc -l < "$PLAN_FILE" | tr -d ' ')
  echo "- Plan lines: $lines"
  if (( lines > 180 )); then
    echo "  ⚠️ Plan is long. Consider compacting before next agent turn."
    WARN=1
  fi
fi

# changed file count in last commit
if git rev-parse --git-dir >/dev/null 2>&1; then
  files=$(git show --name-only --pretty='' HEAD | sed '/^$/d' | wc -l | tr -d ' ')
  echo "- Files in last commit: $files"
  if (( files > 20 )); then
    echo "  ⚠️ Large diff. Prefer split commits and focused review."
    WARN=1
  fi
fi

# review queue size
rq_count=$(find docs/review-queue -type f 2>/dev/null | wc -l | tr -d ' ')
echo "- Pending review request files: $rq_count"
if (( rq_count > 10 )); then
  echo "  ⚠️ Review queue is large. Close old items to reduce context noise."
  WARN=1
fi

if (( WARN == 0 )); then
  echo "✅ No immediate context/cost smell detected."
else
  echo "💡 Suggestion: start fresh session or run compaction before continuing."
fi
