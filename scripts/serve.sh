#!/usr/bin/env bash
# Run the docs site locally (live reload). Run ./scripts/setup.sh first.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV="$ROOT/.venv"

if [ ! -x "$VENV/bin/mkdocs" ]; then
  echo ">> .venv not ready — running setup first"
  "$ROOT/scripts/setup.sh"
fi

echo ">> Starting local docs server at http://127.0.0.1:8000  (Ctrl-C to stop)"
cd "$ROOT"
exec "$VENV/bin/mkdocs" serve --config-file mkdocs.yml
