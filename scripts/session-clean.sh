#!/usr/bin/env bash
set -euo pipefail

echo "🧼 Session Cleanup Helper"
echo

# Detect available tools
HAS_CLAUDE=false
HAS_CODEX=false
command -v claude >/dev/null 2>&1 && HAS_CLAUDE=true
command -v codex >/dev/null 2>&1 && HAS_CODEX=true

echo "Detected tools:"
$HAS_CLAUDE && echo "  ✅ Claude Code" || echo "  ⬜ Claude Code (not found)"
$HAS_CODEX  && echo "  ✅ Codex CLI"   || echo "  ⬜ Codex CLI (not found)"

echo
echo "Recommended actions:"

if $HAS_CLAUDE; then
  echo "  Claude Code: run /clear in your Claude session"
fi

if $HAS_CODEX; then
  echo "  Codex CLI: start a new session (codex) for the next task"
fi

echo
echo "General reminders:"
echo "  1. Close unrelated files/tabs in your IDE"
echo "  2. Clear terminal scrollback if needed"
echo "  3. Review and close old items in docs/review-queue/"

# Clean old review files (> 7 days)
if [[ -d "docs/review-queue" ]]; then
  OLD_REVIEWS=$(find docs/review-queue -maxdepth 1 -name "*.md" -mtime +7 2>/dev/null | wc -l | tr -d ' ')
  if (( OLD_REVIEWS > 0 )); then
    echo
    echo "  📬 Found $OLD_REVIEWS review file(s) older than 7 days"
    read -r -p "  Archive them to docs/review-queue/archive/? (y/N): " ARCHIVE
    if [[ "$ARCHIVE" =~ ^[Yy]$ ]]; then
      mkdir -p docs/review-queue/archive
      find docs/review-queue -maxdepth 1 -name "*.md" -mtime +7 -exec mv {} docs/review-queue/archive/ \;
      echo "  ✅ Archived $OLD_REVIEWS old review file(s)"
    fi
  fi
fi

echo
echo "✅ Session cleanup complete."
