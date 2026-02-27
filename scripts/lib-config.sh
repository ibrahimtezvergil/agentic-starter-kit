#!/usr/bin/env bash
set -euo pipefail

config_get() {
  local key="$1"
  local default_value="${2:-}"
  local cfg="starter.config.yml"

  if [[ ! -f "$cfg" ]]; then
    echo "$default_value"
    return 0
  fi

  # very small YAML reader for flat keys like a.b.c (best effort)
  # fallback to default on parse miss
  local pattern
  pattern="${key//./\\.}"
  local value
  value=$(awk -v k="$pattern" '
    BEGIN{FS=":"}
    {
      line=$0
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", line)
      if (line ~ "^" k ":[[:space:]]*") {
        sub("^" k ":[[:space:]]*", "", line)
        gsub(/^"|"$/, "", line)
        print line
        exit
      }
    }
  ' "$cfg" || true)

  if [[ -z "${value:-}" ]]; then
    echo "$default_value"
  else
    echo "$value"
  fi
}

EXPECTED_KEYS="default_branch risk.high_file_count risk.medium_file_count risk.high_score_threshold risk.medium_score_threshold validation.test_command validation.lint_command validation.build_command"

config_validate() {
  local cfg="starter.config.yml"
  local missing=0
  local placeholder=0

  if [[ ! -f "$cfg" ]]; then
    echo "❌ Config not found: $cfg"
    return 1
  fi

  for key in $EXPECTED_KEYS; do
    local val
    val="$(config_get "$key" "")"
    if [[ -z "$val" ]]; then
      echo "  ⚠️  Missing key: $key"
      missing=$((missing+1))
    elif [[ "$val" == "[set per project]" ]]; then
      echo "  💡 Not configured: $key (using placeholder)"
      placeholder=$((placeholder+1))
    fi
  done

  if (( missing > 0 )); then
    echo "⚠️  $missing missing key(s), $placeholder placeholder(s) in $cfg"
    return 1
  elif (( placeholder > 0 )); then
    echo "⚠️  $placeholder placeholder(s) in $cfg — consider running: scripts/apply-preset.sh <stack>"
    return 0
  else
    echo "✅ Config validation passed"
    return 0
  fi
}
