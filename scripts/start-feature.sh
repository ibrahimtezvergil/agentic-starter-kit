#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: scripts/start-feature.sh <task-slug> [branch-prefix] [--yes|--ci]"
  echo "Example: scripts/start-feature.sh crm-login-timeout-fix feat --yes"
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
PREFIX="${ARGS[1]:-feat}"
BRANCH="${PREFIX}/${TASK_SLUG}"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "❌ Not inside a git repository"
  exit 1
fi

CURRENT="$(git branch --show-current)"
if [[ "$CURRENT" == "$BRANCH" ]]; then
  echo "↪️ Already on $BRANCH"
else
  git checkout -b "$BRANCH"
  echo "✅ Created and switched to $BRANCH"
fi

if [[ "$ASSUME_YES" == "true" ]]; then
  scripts/new-task.sh "$TASK_SLUG" --yes
else
  scripts/new-task.sh "$TASK_SLUG"
fi

echo "\n📌 Next: implement -> test -> commit"
echo "📌 After user tests: scripts/ready-review.sh $TASK_SLUG"
