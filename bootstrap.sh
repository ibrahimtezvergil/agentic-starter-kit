#!/usr/bin/env bash
set -euo pipefail

TOOL="both"
FORCE="false"
DRY_RUN="false"
TARGET=""

usage() {
  cat <<EOF
Usage:
  ./bootstrap.sh <project-path> [--tool codex|claude|gemini|both|all] [--force] [--dry-run]
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

TARGET="$1"
shift || true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tool)
      TOOL="${2:-both}"
      shift 2
      ;;
    --force)
      FORCE="true"
      shift
      ;;
    --dry-run)
      DRY_RUN="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown arg: $1"
      usage
      exit 1
      ;;
  esac
done

if [[ ! -d "$TARGET" ]]; then
  echo "❌ Target path not found: $TARGET"
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
TPL_DIR="$ROOT_DIR/templates"

copy_file() {
  local src="$1"
  local dst="$2"

  if [[ "$DRY_RUN" == "true" ]]; then
    if [[ -f "$dst" && "$FORCE" != "true" ]]; then
      echo "🔍 Would skip (exists): $dst"
    else
      echo "🔍 Would write: $dst"
    fi
    return
  fi

  mkdir -p "$(dirname "$dst")"

  if [[ -f "$dst" && "$FORCE" != "true" ]]; then
    echo "↪️  Skip (exists): $dst"
    return
  fi

  cp "$src" "$dst"
  echo "✅ Wrote: $dst"
}

# Common
copy_file "$TPL_DIR/common/agentignore" "$TARGET/.agentignore"
copy_file "$TPL_DIR/common/AGENTS.md" "$TARGET/AGENTS.md"
copy_file "$TPL_DIR/common/prompt-template.txt" "$TARGET/docs/ai/prompt-template.txt"
copy_file "$TPL_DIR/common/starter.config.yml" "$TARGET/starter.config.yml"

# Wrapper script
copy_file "$TPL_DIR/common/agentic" "$TARGET/agentic"
if [[ "$DRY_RUN" != "true" ]]; then
  chmod +x "$TARGET/agentic" 2>/dev/null || true
fi

# Claude Skills (project-local)
copy_file "$TPL_DIR/claude/skills/bugfix-safe/SKILL.md" "$TARGET/.claude/skills/bugfix-safe/SKILL.md"
copy_file "$TPL_DIR/claude/skills/review-pr-risk/SKILL.md" "$TARGET/.claude/skills/review-pr-risk/SKILL.md"

# Claude Agent Teams templates
copy_file "$TPL_DIR/claude/agents/planner.md" "$TARGET/.claude/agents/planner.md"
copy_file "$TPL_DIR/claude/agents/implementer.md" "$TARGET/.claude/agents/implementer.md"
copy_file "$TPL_DIR/claude/agents/reviewer.md" "$TARGET/.claude/agents/reviewer.md"

case "$TOOL" in
  codex)
    copy_file "$TPL_DIR/codex/config.toml" "$TARGET/.codex/config.toml"
    ;;
  claude)
    copy_file "$TPL_DIR/claude/CLAUDE.md" "$TARGET/CLAUDE.md"
    ;;
  gemini)
    copy_file "$TPL_DIR/gemini/GEMINI.md" "$TARGET/GEMINI.md"
    ;;
  both)
    copy_file "$TPL_DIR/codex/config.toml" "$TARGET/.codex/config.toml"
    copy_file "$TPL_DIR/claude/CLAUDE.md" "$TARGET/CLAUDE.md"
    ;;
  all)
    copy_file "$TPL_DIR/codex/config.toml" "$TARGET/.codex/config.toml"
    copy_file "$TPL_DIR/claude/CLAUDE.md" "$TARGET/CLAUDE.md"
    copy_file "$TPL_DIR/gemini/GEMINI.md" "$TARGET/GEMINI.md"
    ;;
  *)
    echo "❌ Invalid --tool value: $TOOL"
    exit 1
    ;;
esac

# Plugin-ready Claude template (optional by default, always copied as scaffold)
copy_file "$TPL_DIR/claude/plugin/.claude-plugin/plugin.json" "$TARGET/.claude-plugin/plugin.json"
copy_file "$TPL_DIR/claude/plugin/README.md" "$TARGET/.claude-plugin/README.md"
copy_file "$TPL_DIR/claude/plugin/commands/feature-dev.md" "$TARGET/.claude-plugin/commands/feature-dev.md"
copy_file "$TPL_DIR/claude/plugin/hooks/README.md" "$TARGET/.claude-plugin/hooks/README.md"
copy_file "$TPL_DIR/claude/plugin/skills/README.md" "$TARGET/.claude-plugin/skills/README.md"

echo
if [[ "$DRY_RUN" == "true" ]]; then
  echo "🔍 Dry-run complete. No files were written."
else
  echo "🎉 Bootstrap complete for: $TARGET"
fi
echo "Tool mode: $TOOL"
if [[ "$FORCE" == "true" ]]; then
  echo "Overwrite mode: ON"
fi
