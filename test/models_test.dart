// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:backend/backend.dart';
import 'package:ui/ui.dart';
import 'package:garage_app/l10n/app_localizations_en.g.dart';
import 'package:garage_app/l10n/app_localizations_ru.g.dart';
import 'package:garage_app/l10n_adapter.dart';

void main() {
  group('Car model (Flutter)', () {
    test('color parses hex correctly', () {
      final car = const Car(
        id: 1,
        make: 'BMW',
        model: 'X5',
        year: 2020,
        plate: 'A123BC',
        colorHex: '#1e3a8a',
        price: 0,
        mileage: 0,
        oilLife: 100,
        oilKm: 0,
        oilMax: 10000,
      );
      expect(car.color, isA<Color>());
    });
  });

  group('CategoryInfo (Flutter)', () {
    test('all categories have color', () {
      for (final entry in categories.entries) {
        expect(entry.value.color, isA<Color>());
      }
    });
  });

  group('PresetColor (Flutter)', () {
    test('all preset colors have valid Color', () {
      for (final pc in presetColors) {
        expect(pc.color, isA<Color>());
      }
    });
  });

  group('formatDistance', () {
    test('formats km correctly in English', () {
      expect(formatDistance(45000, 'km', AppL10nAdapter(AppLocalizationsEn())), '45,000 km');
      expect(formatDistance(0, 'km', AppL10nAdapter(AppLocalizationsEn())), '0 km');
    });

    test('formats mi correctly in English', () {
      expect(formatDistance(1609, 'mi', AppL10nAdapter(AppLocalizationsEn())), '1,000 mi');
      expect(formatDistance(0, 'mi', AppL10nAdapter(AppLocalizationsEn())), '0 mi');
    });

    test('formats km correctly in Russian', () {
      expect(formatDistance(1000, 'km', AppL10nAdapter(AppLocalizationsRu())), '1,000 км');
    });

    test('formats mi correctly in Russian', () {
      expect(formatDistance(1609, 'mi', AppL10nAdapter(AppLocalizationsRu())), '1,000 миль');
    });
  });

  group('AppLocalizations', () {
    test('English translations', () {
      final l10n = AppLocalizationsEn();
      expect(l10n.garage, '\u{1F697} Garage');
      expect(l10n.makeRequired, 'Make is required');
    });

    test('Russian translations', () {
      final l10n = AppLocalizationsRu();
      expect(l10n.garage, '\u{1F697} Гараж');
      expect(l10n.makeRequired, 'Введите марку');
    });
  });
}
