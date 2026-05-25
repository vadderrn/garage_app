#!/usr/bin/env bash
set -e

echo "=== Creating Flutter project ==="
flutter create . --platforms=android,windows --org vadderrn

echo ""
echo "=== Generating launcher icons ==="
dart run flutter_launcher_icons

echo ""
echo "=== Generating localization files ==="
flutter gen-l10n

echo ""
echo "=== Building backend generated code ==="
(cd packages/backend && dart run build_runner build)

echo ""
echo "=== Building ui generated code ==="
(cd packages/ui && dart run build_runner build)

echo ""
echo "Done. Run 'sh format.sh' to format, 'sh tests.sh' to test."
