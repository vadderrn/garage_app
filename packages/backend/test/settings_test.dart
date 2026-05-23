// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:test/test.dart';
import 'package:backend/backend.dart';

void main() {
  group('AppSettings', () {
    test('uses defaults when no args given', () {
      final s = const AppSettings();
      expect(s.language, 'en');
      expect(s.distanceUnit, 'km');
      expect(s.theme, 'dark');
      expect(s.currency, 'usd');
    });

    test('constructor sets fields', () {
      final s = const AppSettings(
        language: 'ru',
        distanceUnit: 'mi',
        theme: 'light',
        currency: 'eur',
      );
      expect(s.language, 'ru');
      expect(s.distanceUnit, 'mi');
      expect(s.theme, 'light');
      expect(s.currency, 'eur');
    });

    group('copyWith', () {
      final base = const AppSettings(
        language: 'ru',
        distanceUnit: 'mi',
        theme: 'light',
        currency: 'eur',
      );

      test('returns same object when no args', () {
        final copy = base.copyWith();
        expect(copy.language, 'ru');
        expect(copy.distanceUnit, 'mi');
        expect(copy.theme, 'light');
        expect(copy.currency, 'eur');
      });

      test('overrides single field', () {
        final copy = base.copyWith(language: 'en');
        expect(copy.language, 'en');
        expect(copy.distanceUnit, 'mi');
        expect(copy.theme, 'light');
        expect(copy.currency, 'eur');
      });

      test('overrides multiple fields', () {
        final copy = base.copyWith(theme: 'dark', currency: 'rub');
        expect(copy.language, 'ru');
        expect(copy.distanceUnit, 'mi');
        expect(copy.theme, 'dark');
        expect(copy.currency, 'rub');
      });

      test('does not mutate original', () {
        final _ = base.copyWith(language: 'en', theme: 'system');
        expect(base.language, 'ru');
        expect(base.theme, 'light');
      });
    });
  });
}
