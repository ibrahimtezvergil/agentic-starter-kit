#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: scripts/new-task.sh <task-slug> [--yes|--ci]"
  echo "Example: scripts/new-task.sh crm-login-timeout-fix --yes"
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
PLAN_DIR="docs/plans"
PLAN_FILE="$PLAN_DIR/${DATE}-${TASK_SLUG}.md"

mkdir -p "$PLAN_DIR"

if [[ ! -f "$PLAN_FILE" ]]; then
  cat > "$PLAN_FILE" <<EOF
# ${TASK_SLUG} Plan

- Goal:
- Scope:
- Done criteria:
- Risk tier: low|medium|high
- Validation commands:

## Tasks
- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

## Handoff
- Completed:
- Changed files:
- Remaining:
- Test results:
- Risks/notes:
EOF
  echo "✅ Created plan: $PLAN_FILE"
else
  echo "↪️ Plan already exists: $PLAN_FILE"
fi

echo

echo "Session hygiene:"
echo "  Run: scripts/session-clean.sh (or: ./agentic clean)"
echo "  Tip: clear previous agent session if this is a new topic"

echo
if [[ "$ASSUME_YES" == "true" ]]; then
  OPEN_PLAN="N"
else
  read -r -p "Open plan file now? (y/N): " OPEN_PLAN
fi
if [[ "$OPEN_PLAN" =~ ^[Yy]$ ]]; then
  if command -v code >/dev/null 2>&1; then
    code "$PLAN_FILE"
  elif [[ -n "${EDITOR:-}" ]]; then
    "$EDITOR" "$PLAN_FILE"
  else
    echo "No editor configured. File path: $PLAN_FILE"
  fi
fi

echo
if [[ "$ASSUME_YES" == "true" ]]; then
  REMIND="Y"
else
  read -r -p "Mark this as a fresh session start reminder? (y/N): " REMIND
fi
if [[ "$REMIND" =~ ^[Yy]$ ]]; then
  echo "🧼 Reminder: start in a fresh/cleared session before implementation."
fi
