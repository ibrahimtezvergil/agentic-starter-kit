#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/lib-config.sh"

WARN=0
ERR=0

ok()   { echo "  ✅ $1"; }
warn() { echo "  ⚠️  $1"; WARN=$((WARN+1)); }
err()  { echo "  ❌ $1"; ERR=$((ERR+1)); }

echo "🩺 Agentic Health Check"
echo

# --- Core files ---
echo "📄 Core Files"
[[ -f "AGENTS.md" ]]           && ok "AGENTS.md" || err "AGENTS.md missing (run bootstrap)"
[[ -f ".agentignore" ]]        && ok ".agentignore" || err ".agentignore missing"
[[ -f "starter.config.yml" ]]  && ok "starter.config.yml" || err "starter.config.yml missing"

# --- Tool-specific ---
echo "🔧 Tool Config"
[[ -f "CLAUDE.md" ]]           && ok "CLAUDE.md" || warn "CLAUDE.md missing (not needed if not using Claude)"
[[ -f ".codex/config.toml" ]]  && ok ".codex/config.toml" || warn ".codex/config.toml missing"
[[ -f "GEMINI.md" ]]           && ok "GEMINI.md" || warn "GEMINI.md missing (not needed if not using Gemini)"

# --- Skills ---
echo "🧠 Skills"
if [[ -d ".claude/skills" ]]; then
  ok "Claude skills dir"
  SKILL_COUNT=$(find .claude/skills -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
  [[ "$SKILL_COUNT" -gt 0 ]] && ok "$SKILL_COUNT skill(s) found" || warn "No skills found"
else
  warn "No Claude skills installed"
fi

# --- Git hooks ---
echo "🪝 Git Hooks"
if git rev-parse --git-dir > /dev/null 2>&1; then
  if git config core.hooksPath 2>/dev/null | grep -q ".githooks"; then
    ok "Git hooks configured"
    [[ -x ".githooks/post-commit" ]] && ok "post-commit hook" || warn "post-commit not executable"
    [[ -x ".githooks/pre-push" ]]    && ok "pre-push hook" || warn "pre-push not executable"
  else
    warn "Git hooks not installed (run: scripts/install-git-hooks.sh)"
  fi
else
  warn "Not inside a git repository"
fi

# --- Config validation ---
echo "⚙️  Config"
TEST_CMD="$(config_get validation.test_command "[set per project]")"
LINT_CMD="$(config_get validation.lint_command "[set per project]")"
BUILD_CMD="$(config_get validation.build_command "[set per project]")"
[[ "$TEST_CMD" != "[set per project]" ]]  && ok "Test: $TEST_CMD" || warn "validation.test_command not set"
[[ "$LINT_CMD" != "[set per project]" ]]  && ok "Lint: $LINT_CMD" || warn "validation.lint_command not set"
[[ "$BUILD_CMD" != "[set per project]" ]] && ok "Build: $BUILD_CMD" || warn "validation.build_command not set"

# --- Plugin ---
echo "🔌 Plugin"
[[ -f ".claude-plugin/plugin.json" ]] && ok "Plugin scaffold" || warn "No plugin scaffold"

# --- Wrapper ---
echo "📦 Wrapper"
[[ -x "agentic" ]] && ok "./agentic wrapper found" || warn "No agentic wrapper (copy from templates/common/agentic)"

# --- Summary ---
echo
echo "━━━━━━━━━━━━━━━━━━━━━"
if (( ERR > 0 )); then
  echo "💥 $ERR error(s), $WARN warning(s)"
  exit 1
elif (( WARN > 0 )); then
  echo "⚠️  $WARN warning(s), no errors"
else
  echo "🎉 Everything looks good!"
fi
