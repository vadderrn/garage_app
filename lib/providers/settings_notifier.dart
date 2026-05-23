// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/foundation.dart';
import 'package:backend/backend.dart';

class SettingsNotifier extends ChangeNotifier {
  final SettingsRepository _repo;
  AppSettings _settings;

  SettingsNotifier(this._repo, this._settings);

  AppSettings get settings => _settings;
  String get currency => _settings.currency;
  String get distanceUnit => _settings.distanceUnit;
  String get language => _settings.language;

  void update(AppSettings Function(AppSettings) fn) {
    _settings = fn(_settings);
    _repo.save(_settings);
    notifyListeners();
  }
}
