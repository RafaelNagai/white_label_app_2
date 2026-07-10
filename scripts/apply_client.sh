#!/usr/bin/env bash
set -euo pipefail

# Applies a client's white-label config into apps/main_app:
#   - copies configs/<client_id>/config.json into the Flutter app's
#     configuration/ folder (read at runtime via JsonHandler)
#   - regenerates the Android mipmap launcher icons for that client's flavor
#   - regenerates the iOS AppIcon appiconset for that client's flavor
#
# Usage: scripts/apply_client.sh <client_id>
#   e.g.: scripts/apply_client.sh client_a
#
# Requires macOS `sips` (preinstalled) to resize the source icon.png.

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <client_id>" >&2
  echo "Available clients:" >&2
  ls -1 "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/configs" >&2
  exit 1
fi

CLIENT_ID="$1"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$ROOT_DIR/configs/$CLIENT_ID"
APP_DIR="$ROOT_DIR/apps/main_app"

CONFIG_JSON="$CONFIG_DIR/config.json"
ICON_SRC="$CONFIG_DIR/icon.png"

if [[ ! -f "$CONFIG_JSON" ]]; then
  echo "error: $CONFIG_JSON not found" >&2
  exit 1
fi
if [[ ! -f "$ICON_SRC" ]]; then
  echo "error: $ICON_SRC not found" >&2
  exit 1
fi
if ! command -v sips >/dev/null 2>&1; then
  echo "error: 'sips' is required (macOS only) to resize icons" >&2
  exit 1
fi

# client_a -> clientA (matches existing Android flavor / iOS scheme naming)
SUFFIX="${CLIENT_ID#client_}"
FIRST_CHAR="$(printf '%s' "${SUFFIX:0:1}" | tr '[:lower:]' '[:upper:]')"
FLAVOR="client${FIRST_CHAR}${SUFFIX:1}"

echo "==> Client '$CLIENT_ID' -> flavor '$FLAVOR'"

# 1. Copy configuration JSON
CONFIG_OUT_DIR="$APP_DIR/configuration"
mkdir -p "$CONFIG_OUT_DIR"
cp "$CONFIG_JSON" "$CONFIG_OUT_DIR/configuration_app.json"
echo "==> Copied config.json -> ${CONFIG_OUT_DIR#$ROOT_DIR/}/configuration_app.json"

# 2. Android launcher icons (one per density, in the flavor's res dir)
ANDROID_SIZES="mdpi:48 hdpi:72 xhdpi:96 xxhdpi:144 xxxhdpi:192"
for pair in $ANDROID_SIZES; do
  density="${pair%%:*}"
  size="${pair##*:}"
  outdir="$APP_DIR/android/app/src/$FLAVOR/res/mipmap-$density"
  mkdir -p "$outdir"
  sips -z "$size" "$size" "$ICON_SRC" --out "$outdir/ic_launcher.png" >/dev/null
done
echo "==> Generated Android mipmap icons for android/app/src/$FLAVOR"

# 3. iOS AppIcon appiconset (filenames/sizes must match Contents.json)
IOS_ICON_SIZES="Icon-App-20x20@1x.png:20
Icon-App-20x20@2x.png:40
Icon-App-20x20@3x.png:60
Icon-App-29x29@1x.png:29
Icon-App-29x29@2x.png:58
Icon-App-29x29@3x.png:87
Icon-App-40x40@1x.png:40
Icon-App-40x40@2x.png:80
Icon-App-40x40@3x.png:120
Icon-App-60x60@2x.png:120
Icon-App-60x60@3x.png:180
Icon-App-76x76@1x.png:76
Icon-App-76x76@2x.png:152
Icon-App-83.5x83.5@2x.png:167
Icon-App-1024x1024@1x.png:1024"

APPICONSET_DIR="$APP_DIR/ios/Runner/Assets.xcassets/AppIcon-$FLAVOR.appiconset"
mkdir -p "$APPICONSET_DIR"

if [[ ! -f "$APPICONSET_DIR/Contents.json" ]]; then
  cp "$APP_DIR/ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json" "$APPICONSET_DIR/Contents.json"
fi

while IFS=':' read -r filename size; do
  [[ -z "$filename" ]] && continue
  sips -z "$size" "$size" "$ICON_SRC" --out "$APPICONSET_DIR/$filename" >/dev/null
done <<< "$IOS_ICON_SIZES"
echo "==> Generated iOS AppIcon icons for ios/Runner/Assets.xcassets/AppIcon-$FLAVOR.appiconset"

if ! grep -q "create(\"$FLAVOR\")" "$APP_DIR/android/app/build.gradle.kts" 2>/dev/null; then
  echo "warning: no productFlavor \"$FLAVOR\" found in android/app/build.gradle.kts (icons copied, but flavor is not wired yet)" >&2
fi
if [[ ! -f "$APP_DIR/ios/Runner.xcodeproj/xcshareddata/xcschemes/$FLAVOR.xcscheme" ]]; then
  echo "warning: no Xcode scheme '$FLAVOR.xcscheme' found (icons copied, but the flavor is not wired into the Xcode project yet)" >&2
fi

echo "==> Done."
