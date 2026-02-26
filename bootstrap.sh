#!/usr/bin/env bash
set -euo pipefail

TOOL="both"
FORCE="false"
TARGET=""

usage() {
  cat <<EOF
Usage:
  ./bootstrap.sh <project-path> [--tool codex|claude|both] [--force]
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

# Claude Skills (project-local)
copy_file "$TPL_DIR/claude/skills/bugfix-safe/SKILL.md" "$TARGET/.claude/skills/bugfix-safe/SKILL.md"
copy_file "$TPL_DIR/claude/skills/review-pr-risk/SKILL.md" "$TARGET/.claude/skills/review-pr-risk/SKILL.md"

case "$TOOL" in
  codex)
    copy_file "$TPL_DIR/codex/config.toml" "$TARGET/.codex/config.toml"
    ;;
  claude)
    copy_file "$TPL_DIR/claude/CLAUDE.md" "$TARGET/CLAUDE.md"
    ;;
  both)
    copy_file "$TPL_DIR/codex/config.toml" "$TARGET/.codex/config.toml"
    copy_file "$TPL_DIR/claude/CLAUDE.md" "$TARGET/CLAUDE.md"
    ;;
  *)
    echo "❌ Invalid --tool value: $TOOL"
    exit 1
    ;;
esac

echo "\n🎉 Bootstrap complete for: $TARGET"
echo "Tool mode: $TOOL"
if [[ "$FORCE" == "true" ]]; then
  echo "Overwrite mode: ON"
fi
