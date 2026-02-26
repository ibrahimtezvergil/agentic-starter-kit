#!/usr/bin/env bash
set -euo pipefail

ASSUME_YES="false"
ARGS=()
for arg in "$@"; do
  case "$arg" in
    --yes|--ci) ASSUME_YES="true" ;;
    *) ARGS+=("$arg") ;;
  esac
done

BASE_REF="${ARGS[0]:-HEAD~1}"
HEAD_REF="${ARGS[1]:-HEAD}"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "❌ Not inside a git repository"
  exit 1
fi

DIFF_FILES="$(git diff --name-only "$BASE_REF" "$HEAD_REF" 2>/dev/null || true)"
[[ -z "$DIFF_FILES" ]] && DIFF_FILES="$(git show --name-only --pretty='' "$HEAD_REF" 2>/dev/null || true)"

if ! echo "$DIFF_FILES" | grep -Eq '(^|/)database/migrations/|\.sql$'; then
  echo "✅ No migration/sql changes detected."
  exit 0
fi

echo "⚠️ Migration/SQL changes detected."
echo "Changed files:"
echo "$DIFF_FILES" | grep -E '(^|/)database/migrations/|\.sql$' || true

echo
if [[ "$ASSUME_YES" == "true" ]]; then
  ACK="yes"
else
  read -r -p "Did you verify rollback path and user test this migration? (type: yes): " ACK
fi
if [[ "$ACK" != "yes" ]]; then
  echo "❌ Safety gate blocked. Confirm rollback/test readiness first."
  exit 1
fi

echo "✅ Migration safety gate passed."
