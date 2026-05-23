// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:test/test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:backend/backend.dart';

void main() {
  group('SqliteSettingsRepository', () {
    late Database db;
    late SqliteSettingsRepository repo;

    setUp(() {
      db = sqlite3.openInMemory();
      repo = SqliteSettingsRepository(db);
    });

    tearDown(() {
      db.close();
    });

    test('load returns defaults on fresh database', () async {
      final settings = await repo.load();
      expect(settings.language, 'en');
      expect(settings.distanceUnit, 'km');
      expect(settings.theme, 'dark');
      expect(settings.currency, 'usd');
    });

    test('save persists all fields', () async {
      await repo.save(
        const AppSettings(language: 'ru', distanceUnit: 'mi', theme: 'light', currency: 'eur'),
      );
      final loaded = await repo.load();
      expect(loaded.language, 'ru');
      expect(loaded.distanceUnit, 'mi');
      expect(loaded.theme, 'light');
      expect(loaded.currency, 'eur');
    });

    test('load after multiple saves returns latest', () async {
      await repo.save(const AppSettings(language: 'de', theme: 'system', currency: 'rub'));
      await repo.save(const AppSettings(distanceUnit: 'mi', theme: 'light'));
      final loaded = await repo.load();
      expect(loaded.language, 'en');
      expect(loaded.distanceUnit, 'mi');
      expect(loaded.theme, 'light');
      expect(loaded.currency, 'usd');
    });

    test('multiple repositories share the same database', () async {
      await repo.save(const AppSettings(currency: 'eur'));
      final another = SqliteSettingsRepository(db);
      final loaded = await another.load();
      expect(loaded.currency, 'eur');
    });
  });
}
