// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

void main() {
  group('CategoryInfo', () {
    test('all categories have required fields', () {
      for (final entry in categories.entries) {
        expect(entry.value.icon, isNotEmpty);
        expect(entry.value.label, isNotEmpty);
        expect(entry.value.colorValue, isA<int>());
      }
    });

    test('maintenance category exists', () {
      expect(categories.containsKey('maintenance'), true);
      expect(categories['maintenance']!.icon, '\u{1F527}');
    });
  });

  group('PresetColor', () {
    test('all preset colors have valid hex', () {
      for (final pc in presetColors) {
        expect(pc.hex, startsWith('#'));
      }
    });
  });
}
