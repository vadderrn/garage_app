// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'settings.dart';

abstract class SettingsRepository {
  Future<AppSettings> load();
  Future<void> save(AppSettings settings);
}
