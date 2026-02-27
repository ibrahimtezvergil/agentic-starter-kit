#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/lib-config.sh"

if [[ $# -lt 1 ]]; then
  echo "Usage: scripts/end-task.sh <task-slug> [--yes|--ci]"
  echo "Example: scripts/end-task.sh crm-login-timeout-fix --yes"
  exit 1
fi

ASSUME_YES="false"
ARGS=()
for arg in "$@"; do
  case "$arg" in
    --yes|--ci) ASSUME_YES="true" ;;
    *) ARGS+=("$arg") ;;
  esac
done

TASK_SLUG="${ARGS[0]}"
DATE="$(date +%F)"
PLAN_FILE="docs/plans/${DATE}-${TASK_SLUG}.md"

if [[ ! -f "$PLAN_FILE" ]]; then
  echo "⚠️ Plan not found for today: $PLAN_FILE"
  echo "Continuing with checklist only..."
fi

# --- Auto validation ---
run_validation() {
  local label="$1"
  local cmd="$2"
  if [[ -z "$cmd" || "$cmd" == "[set per project]" ]]; then
    echo "  ⏭️  $label: not configured"
    return 0
  fi
  echo "  🔄 $label: $cmd"
  if eval "$cmd"; then
    echo "  ✅ $label passed"
  else
    echo "  ❌ $label failed"
    return 1
  fi
}

echo "🧪 Running validation commands..."
VALIDATION_FAILED=0
run_validation "Test"  "$(config_get validation.test_command)"  || VALIDATION_FAILED=1
run_validation "Lint"  "$(config_get validation.lint_command)"  || VALIDATION_FAILED=1
run_validation "Build" "$(config_get validation.build_command)" || VALIDATION_FAILED=1

if (( VALIDATION_FAILED == 1 )); then
  echo "❌ Validation failed. Fix issues before closing task."
  exit 1
fi
echo "✅ All configured validations passed."

echo
echo "End-of-task checklist:"
echo "- Validation run complete ✅"
echo "- Handoff section updated"
echo "- Ready for review/PR"

echo
if [[ "$ASSUME_YES" == "true" ]]; then
  VERIFIED="Y"
else
  read -r -p "Any additional manual checks completed? (Y/n): " VERIFIED
fi
if [[ "$VERIFIED" =~ ^[Nn]$ ]]; then
  echo "❌ Stop: complete manual checks before closing task."
  exit 1
fi

echo
if [[ -f "$PLAN_FILE" ]]; then
  echo "📝 Update handoff in: $PLAN_FILE"
  scripts/context-cost-guard.sh "$PLAN_FILE" || true
fi

if [[ "$ASSUME_YES" == "true" ]]; then
  RUN_MIGRATION_GATE="Y"
else
  read -r -p "Run migration safety gate before finishing? (y/N): " RUN_MIGRATION_GATE
fi
if [[ "$RUN_MIGRATION_GATE" =~ ^[Yy]$ ]]; then
  if [[ "$ASSUME_YES" == "true" ]]; then
    scripts/migration-safety-gate.sh HEAD~1 HEAD --yes
  else
    scripts/migration-safety-gate.sh HEAD~1 HEAD
  fi
fi

if [[ "$ASSUME_YES" == "true" ]]; then
  CLEAR_HINT="Y"
else
  read -r -p "Do you want a session clear reminder now? (Y/n): " CLEAR_HINT
fi
if [[ ! "$CLEAR_HINT" =~ ^[Nn]$ ]]; then
  echo "🧼 Reminder: clear/rotate session if next task is unrelated."
fi

echo "✅ Task close flow completed."
