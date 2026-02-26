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
  pattern=$(echo "$key" | sed 's/\./\\./g')
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
