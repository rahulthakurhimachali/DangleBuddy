#!/bin/bash
# Renders every built-in charm to Assets.xcassets/CharmPreviews, and a collection
# sheet to Assets/Screenshots/collection-sheet.png. Re-run after changing artwork.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="$(mktemp -d)"
SDK="$(xcrun --show-sdk-path --sdk macosx)"

xcrun swiftc -target arm64-apple-macos14.0 -sdk "$SDK" -swift-version 6 -O -parse-as-library \
  -o "$BUILD/previews" \
  "$ROOT"/DangleBuddy/Models/Charm.swift \
  "$ROOT"/DangleBuddy/Models/CharmSound.swift \
  "$ROOT"/DangleBuddy/Models/SVGArtworkSource.swift \
  "$ROOT"/DangleBuddy/Models/Charms/*.swift \
  "$ROOT"/DangleBuddy/Utilities/Comparable+Clamped.swift \
  "$ROOT"/DangleBuddy/Utilities/VectorImage.swift \
  "$ROOT"/DangleBuddy/Utilities/RGBABitmap.swift \
  "$ROOT"/DangleBuddy/Views/Overlay/CharmRenderer.swift \
  "$ROOT"/DangleBuddy/Views/Overlay/CharmView.swift \
  "$ROOT"/Scripts/GenerateCharmPreviews.swift

mkdir -p "$ROOT/Assets/Screenshots"
# The collection's artwork is read straight from the designer's SVGs.
export DANGLEBUDDY_CHARM_SVG_DIR="$ROOT/Assets/Charms"
"$BUILD/previews" "$ROOT/DangleBuddy/Assets/Assets.xcassets/CharmPreviews" "$ROOT/Assets/Screenshots/collection-sheet.png"
rm -rf "$BUILD"
