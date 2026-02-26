#!/usr/bin/env bash
set -euo pipefail

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "❌ Not inside a git repository"
  exit 1
fi

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

mkdir -p .githooks

cat > .githooks/post-commit <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${CI:-}" ]]; then
  exit 0
fi

printf "\n🧪 Commit created. Start review now? (y/N): "
read -r ANSWER || true
if [[ ! "$ANSWER" =~ ^[Yy]$ ]]; then
  echo "↪️ Skipped review trigger. Run scripts/ready-review.sh <task-slug> when ready."
  exit 0
fi

printf "Task slug (e.g. crm-login-timeout-fix): "
read -r TASK_SLUG || true
if [[ -z "${TASK_SLUG:-}" ]]; then
  echo "⚠️ No task slug entered. Skipping review trigger."
  exit 0
fi

if [[ -x "scripts/ready-review.sh" ]]; then
  scripts/ready-review.sh "$TASK_SLUG"
else
  echo "⚠️ scripts/ready-review.sh not found or not executable"
fi
EOF

chmod +x .githooks/post-commit

# Use repo-local hooks path
git config core.hooksPath .githooks

echo "✅ Git hook installed: .githooks/post-commit"
echo "✅ core.hooksPath set to .githooks"
