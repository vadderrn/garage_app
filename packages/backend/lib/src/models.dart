// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
abstract class WorkRecord with _$WorkRecord {
  const factory WorkRecord({
    required int id,
    required String description,
    required String date,
    required int cost,
    required String category,
    @Default(null) int? mileage,
  }) = _WorkRecord;

  const WorkRecord._();

  factory WorkRecord.fromJson(Map<String, dynamic> json) => _$WorkRecordFromJson(json);
}

@freezed
abstract class Car with _$Car {
  const factory Car({
    required int id,
    required String make,
    required String model,
    required int year,
    required String plate,
    @JsonKey(name: 'color_hex') required String colorHex,
    required int price,
    required int mileage,
    @JsonKey(name: 'oil_life') required int oilLife,
    @JsonKey(name: 'oil_km') required int oilKm,
    @JsonKey(name: 'oil_max') required int oilMax,
    @JsonKey(includeFromJson: false, includeToJson: false) @Default([]) List<WorkRecord> works,
  }) = _Car;

  const Car._();

  factory Car.fromJson(Map<String, dynamic> json) => _$CarFromJson(json);

  int get totalSpent => works.fold(0, (s, w) => s + w.cost);
  String get lastService => works.isNotEmpty ? works.first.date : 'N/A';
  int get avgSpent => works.isNotEmpty ? totalSpent ~/ works.length : 0;

  Map<String, int> get categoryTotals {
    final map = <String, int>{};
    for (final w in works) {
      map[w.category] = (map[w.category] ?? 0) + w.cost;
    }
    return map;
  }

  MapEntry<String, int>? get topCategory {
    final entries = categoryTotals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return entries.isNotEmpty ? entries.first : null;
  }
}
