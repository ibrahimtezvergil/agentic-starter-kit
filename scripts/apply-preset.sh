#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: scripts/apply-preset.sh <react|laravel|node-api|python>"
  exit 1
fi

PRESET="$1"
SRC="templates/common/presets/starter.config.${PRESET}.yml"
DST="starter.config.yml"

if [[ ! -f "$SRC" ]]; then
  echo "❌ Preset not found: $PRESET"
  echo "Available: react, laravel, node-api, python"
  exit 1
fi

cp "$SRC" "$DST"
echo "✅ Applied preset: $PRESET -> $DST"
