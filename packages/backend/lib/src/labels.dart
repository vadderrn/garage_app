// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'formatting.dart';
import 'l10n.dart';

class SettingsOption {
  final String value;
  final String label;
  const SettingsOption(this.value, this.label);
}

class MonthlyEntry {
  final String name;
  final int spent;
  final int count;
  const MonthlyEntry({required this.name, required this.spent, required this.count});
}

String catLabel(L10n l10n, String key) {
  return switch (key) {
    'maintenance' => l10n.catMaintenance,
    'repair' => l10n.catRepair,
    'replacement' => l10n.catReplacement,
    'diagnostic' => l10n.catDiagnostic,
    'tires' => l10n.catTires,
    'fuel' => l10n.catFuel,
    'insurance' => l10n.catInsurance,
    'cleaning' => l10n.catCleaning,
    'tax' => l10n.catTax,
    'parking' => l10n.catParking,
    'other' => l10n.catOther,
    _ => key,
  };
}

String monthName(L10n l10n, int month) {
  return switch (month) {
    0 => l10n.month0,
    1 => l10n.month1,
    2 => l10n.month2,
    3 => l10n.month3,
    4 => l10n.month4,
    5 => l10n.month5,
    6 => l10n.month6,
    7 => l10n.month7,
    8 => l10n.month8,
    9 => l10n.month9,
    10 => l10n.month10,
    11 => l10n.month11,
    _ => '',
  };
}

String formatDistance(int km, String unit, L10n l10n) {
  final value = unit == 'mi' ? (km / 1.609).round() : km;
  final label = unit == 'mi' ? l10n.mi : l10n.km;
  return '${value.formatNum()} $label';
}

String todayDateString() => DateTime.now().toIso8601String().substring(0, 10);

String formatMonth(int month) => month.toString().padLeft(2, '0');

const githubUrl = 'https://github.com/vadderrn';
const boostyUrl = 'https://boosty.to/vadderrn/donate';
