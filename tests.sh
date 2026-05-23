#!/usr/bin/env bash
set -e

echo "=== garage_app (Flutter) ==="
flutter test "$@"

echo ""
echo "=== backend (pure Dart) ==="
(cd packages/backend && dart test "$@")

echo ""
echo "=== ui (Flutter) ==="
(cd packages/ui && flutter test "$@")

echo ""
echo "All tests passed."
