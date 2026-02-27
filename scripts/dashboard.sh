#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/lib-config.sh"

echo "📊 Agentic Dashboard"
echo "━━━━━━━━━━━━━━━━━━━━━"

# --- Active plans ---
PLAN_DIR="docs/plans"
if [[ -d "$PLAN_DIR" ]]; then
  PLANS=$(find "$PLAN_DIR" -name "*.md" -mtime -7 2>/dev/null | sort -r || true)
  PLAN_COUNT=$(echo "$PLANS" | sed '/^$/d' | wc -l | tr -d ' ')
  echo
  echo "📋 Recent Plans (last 7 days): $PLAN_COUNT"
  if [[ -n "$PLANS" ]]; then
    while IFS= read -r plan; do
      [[ -z "$plan" ]] && continue
      slug=$(basename "$plan" .md)
      risk=$(grep -i "risk tier" "$plan" 2>/dev/null | head -1 | sed 's/.*: *//' || echo "?")
      done_items=$(grep -c '\[x\]' "$plan" 2>/dev/null || echo 0)
      total_items=$(grep -cE '\[[ x/]\]' "$plan" 2>/dev/null || echo 0)
      echo "  📄 $slug  [Risk: $risk]  [Progress: $done_items/$total_items]"
    done <<< "$PLANS"
  fi
else
  echo
  echo "📋 No plans directory found"
fi

# --- Review queue ---
REVIEW_DIR="docs/review-queue"
if [[ -d "$REVIEW_DIR" ]]; then
  RQ_COUNT=$(find "$REVIEW_DIR" -maxdepth 1 -type f -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
  echo
  echo "📬 Pending Reviews: $RQ_COUNT"
  if (( RQ_COUNT > 5 )); then
    echo "  ⚠️  Queue is getting large. Consider processing pending reviews."
  fi
else
  echo
  echo "📬 No review queue yet"
fi

# --- PR packages ---
PR_DIR="docs/pr-packages"
if [[ -d "$PR_DIR" ]]; then
  PR_COUNT=$(find "$PR_DIR" -maxdepth 1 -type f -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
  echo
  echo "📦 PR Packages: $PR_COUNT"
fi

# --- Current branch & risk ---
if git rev-parse --git-dir > /dev/null 2>&1; then
  BRANCH=$(git branch --show-current)
  RISK=$(scripts/analyze-risk.sh HEAD~1 HEAD 2>/dev/null || echo "n/a")
  echo
  echo "🌿 Current Branch: $BRANCH"
  echo "⚡ Last Commit Risk: $RISK"

  UNCOMMITTED=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  if (( UNCOMMITTED > 0 )); then
    echo "  📝 $UNCOMMITTED uncommitted change(s)"
  fi
fi

# --- Cost guard summary ---
echo
scripts/context-cost-guard.sh 2>/dev/null || true

echo
echo "━━━━━━━━━━━━━━━━━━━━━"
