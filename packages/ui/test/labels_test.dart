// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:backend/backend.dart';
import 'src/mock_l10n.dart';

void main() {
  final l10n = MockL10n();

  group('catLabel', () {
    test('returns correct label for maintenance', () {
      expect(catLabel(l10n, 'maintenance'), 'Maintenance');
    });
    test('returns correct label for repair', () {
      expect(catLabel(l10n, 'repair'), 'Repair');
    });
    test('returns correct label for replacement', () {
      expect(catLabel(l10n, 'replacement'), 'Replacement');
    });
    test('returns correct label for diagnostic', () {
      expect(catLabel(l10n, 'diagnostic'), 'Diagnostic');
    });
    test('returns correct label for tires', () {
      expect(catLabel(l10n, 'tires'), 'Tires');
    });
    test('returns correct label for fuel', () {
      expect(catLabel(l10n, 'fuel'), 'Fuel');
    });
    test('returns correct label for insurance', () {
      expect(catLabel(l10n, 'insurance'), 'Insurance');
    });
    test('returns correct label for cleaning', () {
      expect(catLabel(l10n, 'cleaning'), 'Cleaning');
    });
    test('returns correct label for tax', () {
      expect(catLabel(l10n, 'tax'), 'Tax');
    });
    test('returns correct label for parking', () {
      expect(catLabel(l10n, 'parking'), 'Parking');
    });
    test('returns correct label for other', () {
      expect(catLabel(l10n, 'other'), 'Other');
    });
    test('returns key string for unknown category', () {
      expect(catLabel(l10n, 'unknown'), 'unknown');
    });
  });

  group('monthName', () {
    test('returns January for 0', () {
      expect(monthName(l10n, 0), 'January');
    });
    test('returns June for 5', () {
      expect(monthName(l10n, 5), 'June');
    });
    test('returns December for 11', () {
      expect(monthName(l10n, 11), 'December');
    });
    test('returns empty string for out of range', () {
      expect(monthName(l10n, -1), '');
      expect(monthName(l10n, 12), '');
    });
  });

  group('formatDistance', () {
    test('formats km with commas', () {
      expect(formatDistance(1000, 'km', l10n), '1,000 km');
    });
    test('formats zero km', () {
      expect(formatDistance(0, 'km', l10n), '0 km');
    });
    test('converts to mi correctly', () {
      expect(formatDistance(1609, 'mi', l10n), '1,000 mi');
    });
    test('formats zero mi', () {
      expect(formatDistance(0, 'mi', l10n), '0 mi');
    });
  });

  group('SettingsOption', () {
    test('stores value and label', () {
      const opt = SettingsOption('en', 'English');
      expect(opt.value, 'en');
      expect(opt.label, 'English');
    });
  });

  group('MonthlyEntry', () {
    test('stores name, spent, count', () {
      const entry = MonthlyEntry(name: 'January', spent: 500, count: 3);
      expect(entry.name, 'January');
      expect(entry.spent, 500);
      expect(entry.count, 3);
    });
    test('const constructor', () {
      const entry = MonthlyEntry(name: 'Feb', spent: 0, count: 0);
      expect(entry.name, 'Feb');
    });
  });
}
