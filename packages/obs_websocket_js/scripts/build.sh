#!/usr/bin/env bash
# Compiles the Dart interop entry point into JavaScript using dart2js.
#
# Output: build/dart/obs_websocket.js (ES module installing globalThis.ObsWebSocketJs)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${PKG_DIR}"

echo "==> Fetching Dart dependencies"
dart pub get

mkdir -p build/dart

echo "==> Compiling Dart -> JavaScript (dart2js -O4)"
dart compile js \
  -O4 \
  --server-mode \
  -o build/dart/obs_websocket.js \
  lib/obs_websocket_js.dart

# Remove the sibling .deps file that dart2js emits (not needed in dist).
rm -f build/dart/obs_websocket.js.deps

# Copy to dist/ so tsup-external dynamic imports resolve at runtime.
mkdir -p dist
cp build/dart/obs_websocket.js dist/obs_websocket.runtime.js

echo "==> Dart runtime built: $(du -h build/dart/obs_websocket.js | cut -f1)"
