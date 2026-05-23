// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';

@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default('en') String language,
    @Default('km') String distanceUnit,
    @Default('dark') String theme,
    @Default('usd') String currency,
  }) = _AppSettings;

  const AppSettings._();
}
