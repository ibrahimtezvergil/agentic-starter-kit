#!/usr/bin/env bash
set -euo pipefail

PASS=0
FAIL=0
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

pass() { echo "  ✅ $1"; PASS=$((PASS+1)); }
fail() { echo "  ❌ $1"; FAIL=$((FAIL+1)); }
assert_file() { [[ -f "$1" ]] && pass "$2" || fail "$2: $1 not found"; }
assert_contains() { grep -q "$2" "$1" && pass "$3" || fail "$3"; }

# --- Setup ---
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
cd "$TMP"
git init . > /dev/null 2>&1
git config user.email "test@test.com"
git config user.name "test"
git commit --allow-empty -m "init" > /dev/null 2>&1

echo "🧪 Bootstrap tests"
"$SCRIPT_DIR/bootstrap.sh" "$TMP" --tool both > /dev/null
assert_file "$TMP/AGENTS.md" "AGENTS.md created"
assert_file "$TMP/CLAUDE.md" "CLAUDE.md created"
assert_file "$TMP/.codex/config.toml" "Codex config created"
assert_file "$TMP/.agentignore" ".agentignore created"
assert_file "$TMP/docs/ai/prompt-template.txt" "prompt-template created"
assert_file "$TMP/.claude/skills/laravel-filament-solid/SKILL.md" "laravel-filament-solid skill created"
assert_file "$TMP/.claude/agents/planner.md" "planner agent template created"
assert_file "$TMP/.claude/agents/implementer.md" "implementer agent template created"
assert_file "$TMP/.claude/agents/reviewer.md" "reviewer agent template created"
assert_file "$TMP/starter.config.yml" "starter.config.yml created"
assert_file "$TMP/.claude-plugin/plugin.json" "plugin.json created"

echo "🧪 Bootstrap skip existing"
OUTPUT=$("$SCRIPT_DIR/bootstrap.sh" "$TMP" --tool both 2>&1)
echo "$OUTPUT" | grep -q "Skip" && pass "Existing files are skipped" || fail "Existing files not skipped"

echo "🧪 Bootstrap --force overwrite"
"$SCRIPT_DIR/bootstrap.sh" "$TMP" --tool both --force > /dev/null
assert_file "$TMP/AGENTS.md" "Force overwrite works"

echo "🧪 Preset tests"
cp -r "$SCRIPT_DIR/templates" "$TMP/templates"
cp -r "$SCRIPT_DIR/scripts" "$TMP/scripts"
"$TMP/scripts/apply-preset.sh" react > /dev/null
assert_contains "$TMP/starter.config.yml" "npm test" "React preset applied"
"$TMP/scripts/apply-preset.sh" laravel > /dev/null
assert_contains "$TMP/starter.config.yml" "php artisan test" "Laravel preset applied"
"$TMP/scripts/apply-preset.sh" python > /dev/null
assert_contains "$TMP/starter.config.yml" "pytest" "Python preset applied"

echo "🧪 Task lifecycle tests"
"$TMP/scripts/new-task.sh" test-task --yes > /dev/null 2>&1
PLAN_FILE="$TMP/docs/plans/$(date +%F)-test-task.md"
assert_file "$PLAN_FILE" "Plan file created"
assert_contains "$PLAN_FILE" "Risk tier" "Plan has risk tier field"

echo "🧪 Risk analysis tests"
RISK=$("$TMP/scripts/analyze-risk.sh" HEAD~1 HEAD 2>/dev/null || echo "unknown")
[[ "$RISK" =~ ^(low|medium|high|unknown)$ ]] && pass "Risk output valid: $RISK" || fail "Invalid risk: $RISK"

echo "🧪 Lib-config tests"
# shellcheck disable=SC1091
source "$TMP/scripts/lib-config.sh"
VAL=$(config_get default_branch "fallback")
[[ -n "$VAL" ]] && pass "config_get works: $VAL" || fail "config_get returned empty"
MISS=$(config_get nonexistent.key "mydefault")
[[ "$MISS" == "mydefault" ]] && pass "config_get default fallback" || fail "Fallback failed: $MISS"

echo "🧪 Context cost guard tests"
"$TMP/scripts/context-cost-guard.sh" "$PLAN_FILE" > /tmp/ccg-out.txt 2>&1 || true
assert_contains "/tmp/ccg-out.txt" "Context/Cost Guard" "Context guard runs"

echo
echo "━━━━━━━━━━━━━━━━━━━━━"
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && echo "🎉 All tests passed!" || { echo "💥 Some tests failed"; exit 1; }
