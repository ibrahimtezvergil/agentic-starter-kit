#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: scripts/start-feature.sh <task-slug> [branch-prefix]"
  echo "Example: scripts/start-feature.sh crm-login-timeout-fix feat"
  exit 1
fi

TASK_SLUG="$1"
PREFIX="${2:-feat}"
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

scripts/new-task.sh "$TASK_SLUG"

echo "\n📌 Next: implement -> test -> commit"
echo "📌 After user tests: scripts/ready-review.sh $TASK_SLUG"
