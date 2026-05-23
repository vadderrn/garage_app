#!/usr/bin/env sh
set -e

echo "=== backend (pure Dart) ==="
(cd packages/backend && dart analyze)

echo ""
echo "=== ui (Flutter) ==="
(cd packages/ui && flutter analyze)

echo ""
echo "=== garage_app (Flutter) ==="
flutter analyze
