#!/usr/bin/env bash
# Build the static site into ./site/ (local/static hosts).
# GitLab Pages is published from CI (.gitlab-ci.yml) into public/.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV="$ROOT/.venv"

if [ ! -x "$VENV/bin/mkdocs" ]; then
  echo ">> .venv not ready — running setup first"
  "$ROOT/scripts/setup.sh"
fi

cd "$ROOT"
"$VENV/bin/mkdocs" build --config-file mkdocs.yml --clean
echo ">> Static site written to $ROOT/site/"
