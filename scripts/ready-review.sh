#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/lib-config.sh"

if [[ $# -lt 1 ]]; then
  echo "Usage: scripts/ready-review.sh <task-slug> [--yes|--ci]"
  echo "Example: scripts/ready-review.sh crm-login-timeout-fix --yes"
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
REVIEW_DIR="docs/review-queue"
TS="$(date +%Y%m%d-%H%M%S)"
OUT_FILE="$REVIEW_DIR/${TS}-${TASK_SLUG}-review-request.md"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "❌ Not inside a git repository"
  exit 1
fi

LAST_SHA="$(git rev-parse --short HEAD)"
BRANCH="$(git branch --show-current)"
CHANGED_FILES="$(git show --name-only --pretty='' HEAD | sed '/^$/d' | sort -u)"
RISK="$(scripts/analyze-risk.sh HEAD~1 HEAD 2>/dev/null || echo unknown)"

# Gather validation commands from config
VAL_TEST="$(config_get validation.test_command "")"
VAL_LINT="$(config_get validation.lint_command "")"
VAL_BUILD="$(config_get validation.build_command "")"
VALIDATION_SECTION=""
[[ -n "$VAL_TEST" && "$VAL_TEST" != "[set per project]" ]] && VALIDATION_SECTION="- Test: \`$VAL_TEST\`"$'\n'
[[ -n "$VAL_LINT" && "$VAL_LINT" != "[set per project]" ]] && VALIDATION_SECTION="${VALIDATION_SECTION}- Lint: \`$VAL_LINT\`"$'\n'
[[ -n "$VAL_BUILD" && "$VAL_BUILD" != "[set per project]" ]] && VALIDATION_SECTION="${VALIDATION_SECTION}- Build: \`$VAL_BUILD\`"$'\n'

mkdir -p "$REVIEW_DIR"
LAST_FILE_FOR_SHA="$(grep -Rsl "^- Commit: ${LAST_SHA}$" "$REVIEW_DIR" 2>/dev/null | head -n 1 || true)"
if [[ -n "$LAST_FILE_FOR_SHA" ]]; then
  if [[ "$ASSUME_YES" == "true" ]]; then
    echo "↪️ Existing review request found for this commit: $LAST_FILE_FOR_SHA"
    exit 0
  fi
  read -r -p "Review request already exists for commit ${LAST_SHA}. Create another? (y/N): " CREATE_DUP
  if [[ ! "$CREATE_DUP" =~ ^[Yy]$ ]]; then
    echo "↪️ Skipped duplicate review request."
    exit 0
  fi
fi

cat > "$OUT_FILE" <<EOF
# Review Request

- Task: ${TASK_SLUG}
- Branch: ${BRANCH}
- Commit: ${LAST_SHA}
- Created: $(date)
- Auto Risk: ${RISK}

## Plan File
$(if [[ -f "$PLAN_FILE" ]]; then echo "- ${PLAN_FILE}"; else echo "- (not found for today) expected: ${PLAN_FILE}"; fi)

## Changed Files
${CHANGED_FILES:-"(no changed files found in last commit)"}

## Validation Commands
${VALIDATION_SECTION:-"(not configured in starter.config.yml)"}

## Reviewer Instructions
Please run a risk-first review:
1. Security
2. Correctness / bugs
3. Race/concurrency risks
4. Test quality gaps
5. Maintainability concerns

Output format:
- Summary risk score: Low/Medium/High
- Prioritized findings with severity + file + fix suggestion
- Merge recommendation: Approve / Request changes
EOF

echo "✅ Review request generated: $OUT_FILE"
echo "➡️ Send this to Claude Code (or your reviewer agent) when you're ready."

