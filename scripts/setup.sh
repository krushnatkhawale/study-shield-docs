#!/usr/bin/env bash
# One-time setup: create a Python virtualenv and install MkDocs + Material theme.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV="$ROOT/.venv"

if [ ! -x "$VENV/bin/python" ]; then
  echo ">> Creating virtualenv at $VENV"
  python3 -m venv "$VENV"
fi

echo ">> Installing MkDocs + Material theme"
"$VENV/bin/pip" install --quiet --upgrade "mkdocs" "mkdocs-material"

echo ">> Writing requirements.txt"
"$VENV/bin/pip" freeze | grep -iE "^(mkdocs|mkdocs-material|pymdown-extensions|markdown)" > "$ROOT/requirements.txt"

echo ">> Setup complete. Run ./scripts/serve.sh to preview."
