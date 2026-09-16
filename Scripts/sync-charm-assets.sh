#!/bin/bash
# Syncs the designer's SVGs in Assets/Charms into the asset catalog as
# vector-preserving imagesets. Re-run whenever an SVG changes, then
# Scripts/generate-charm-previews.sh to refresh the previews.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="$(mktemp -d)"
SDK="$(xcrun --show-sdk-path --sdk macosx)"

xcrun swiftc -target arm64-apple-macos14.0 -sdk "$SDK" -swift-version 6 -parse-as-library \
  -o "$BUILD/sync" \
  "$ROOT"/DangleBuddy/Models/Charm.swift \
  "$ROOT"/DangleBuddy/Models/CharmSound.swift \
  "$ROOT"/DangleBuddy/Models/SVGArtworkSource.swift \
  "$ROOT"/DangleBuddy/Models/Charms/*.swift \
  "$ROOT"/DangleBuddy/Utilities/Comparable+Clamped.swift \
  "$ROOT"/DangleBuddy/Utilities/VectorImage.swift \
  "$ROOT"/DangleBuddy/Utilities/RGBABitmap.swift \
  "$ROOT"/Scripts/SyncCharmAssets.swift

"$BUILD/sync" "$ROOT/Assets/Charms" "$ROOT/DangleBuddy/Assets/Assets.xcassets/CharmArtwork"
rm -rf "$BUILD"
