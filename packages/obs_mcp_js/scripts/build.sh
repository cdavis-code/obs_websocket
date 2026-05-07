#!/bin/bash
set -e
cd "$(dirname "$0")/.."

echo "Installing Dart dependencies..."
dart pub get

echo "Compiling Dart to JavaScript..."
dart compile js -O4 -o build/dart/obs_mcp_server.js lib/obs_mcp_js.dart

echo "Copying to dist..."
mkdir -p dist
cp build/dart/obs_mcp_server.js dist/obs_mcp_server.runtime.js

# Also copy the .js.map file if it exists (for debugging)
if [ -f build/dart/obs_mcp_server.js.map ]; then
  cp build/dart/obs_mcp_server.js.map dist/obs_mcp_server.runtime.js.map
fi

echo "Build complete!"
