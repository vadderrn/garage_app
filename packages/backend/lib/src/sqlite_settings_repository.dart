// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:sqlite3/sqlite3.dart';
import 'settings.dart';
import 'settings_repository.dart';
import 'sql_queries.dart';

class SqliteSettingsRepository implements SettingsRepository {
  final Database _db;

  SqliteSettingsRepository(this._db) {
    _db.execute(createSettingsTableSQL);
    _db.execute(insertDefaultSettingsSQL);
  }

  @override
  Future<AppSettings> load() async {
    final row = _db.select(loadSettingsSQL).first;
    return AppSettings(
      language: row['language'] as String,
      distanceUnit: row['distance_unit'] as String,
      theme: row['theme'] as String,
      currency: row['currency'] as String,
    );
  }

  @override
  Future<void> save(AppSettings settings) async {
    _db.execute(updateSettingsSQL, [
      settings.language,
      settings.distanceUnit,
      settings.theme,
      settings.currency,
    ]);
  }
}
