#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: scripts/end-task.sh <task-slug>"
  echo "Example: scripts/end-task.sh crm-login-timeout-fix"
  exit 1
fi

TASK_SLUG="$1"
DATE="$(date +%F)"
PLAN_FILE="docs/plans/${DATE}-${TASK_SLUG}.md"

if [[ ! -f "$PLAN_FILE" ]]; then
  echo "⚠️ Plan not found for today: $PLAN_FILE"
  echo "Continuing with checklist only..."
fi

echo "End-of-task checklist:"
echo "- Verification run complete (test/lint/build)"
echo "- Handoff section updated"
echo "- Ready for review/PR"

echo
read -r -p "Did you run verification commands successfully? (y/N): " VERIFIED
if [[ ! "$VERIFIED" =~ ^[Yy]$ ]]; then
  echo "❌ Stop: run verification before closing task."
  exit 1
fi

echo
if [[ -f "$PLAN_FILE" ]]; then
  echo "📝 Update handoff in: $PLAN_FILE"
  scripts/context-cost-guard.sh "$PLAN_FILE" || true
fi

read -r -p "Run migration safety gate before finishing? (y/N): " RUN_MIGRATION_GATE
if [[ "$RUN_MIGRATION_GATE" =~ ^[Yy]$ ]]; then
  scripts/migration-safety-gate.sh HEAD~1 HEAD
fi

read -r -p "Do you want a session clear reminder now? (Y/n): " CLEAR_HINT
if [[ ! "$CLEAR_HINT" =~ ^[Nn]$ ]]; then
  echo "🧼 Reminder: clear/rotate session if next task is unrelated."
fi

echo "✅ Task close flow completed."
