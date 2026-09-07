#!/usr/bin/env bash
# Regenerate the C4 diagrams (PlantUML + C4-PlantUML stdlib vendored in diagrams/c4stdlib/).
# Requires: plantuml (brew install plantuml)
set -euo pipefail
cd "$(dirname "$0")/.."

RELATIVE_INCLUDE="diagrams/c4stdlib"

echo "Rendering diagrams/...*"
plantuml -tsvg -DRELATIVE_INCLUDE="$RELATIVE_INCLUDE" diagrams/system-context.puml diagrams/container.puml diagrams/backend-component.puml diagrams/mobile-tv-component.puml
plantuml -tpng -DRELATIVE_INCLUDE="$RELATIVE_INCLUDE" diagrams/system-context.puml diagrams/container.puml diagrams/backend-component.puml diagrams/mobile-tv-component.puml

echo "Copying outputs into docs/images/"
mkdir -p docs/images
cp diagrams/system-context.svg  docs/images/c4-system-context.svg
cp diagrams/container.svg       docs/images/c4-container.svg
cp diagrams/backend-component.svg docs/images/c4-backend-component.svg
cp diagrams/mobile-tv-component.svg docs/images/c4-mobile-tv-component.svg
cp diagrams/system-context.png  docs/images/c4-system-context.png
cp diagrams/container.png       docs/images/c4-container.png
cp diagrams/backend-component.png docs/images/c4-backend-component.png
cp diagrams/mobile-tv-component.png docs/images/c4-mobile-tv-component.png

echo "Done. Outputs committed to docs/images/ (next: ./scripts/build.sh)"