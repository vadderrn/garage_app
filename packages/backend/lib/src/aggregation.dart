// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'models.dart';

int getMonthYearSpending(Car car, int offset, [DateTime? now]) {
  now ??= DateTime.now();
  final targetMonth = resolveMonthOffset(offset, now);
  final targetYear = resolveYearOffset(offset, now);
  return car.works
      .where((w) {
        final d = DateTime.tryParse(w.date);
        if (d == null) return false;
        return d.month == targetMonth + 1 && d.year == targetYear;
      })
      .fold(0, (s, w) => s + w.cost);
}

int getMonthYearWorkCount(Car car, int offset, [DateTime? now]) {
  now ??= DateTime.now();
  final targetMonth = resolveMonthOffset(offset, now);
  final targetYear = resolveYearOffset(offset, now);
  return car.works.where((w) {
    final d = DateTime.tryParse(w.date);
    if (d == null) return false;
    return d.month == targetMonth + 1 && d.year == targetYear;
  }).length;
}

int resolveMonthOffset(int offset, DateTime now) {
  final m = now.month - 1 - offset;
  if (m >= 0) return m;
  return m + 12;
}

int resolveYearOffset(int offset, DateTime now) {
  var m = now.month - 1 - offset;
  var y = now.year;
  while (m < 0) {
    m += 12;
    y--;
  }
  return y;
}
