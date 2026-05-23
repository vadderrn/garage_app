// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
abstract class CategoryInfo with _$CategoryInfo {
  const factory CategoryInfo({
    required String icon,
    required String label,
    required int colorValue,
  }) = _CategoryInfo;

  const CategoryInfo._();

  factory CategoryInfo.fromJson(Map<String, dynamic> json) => _$CategoryInfoFromJson(json);
}

@freezed
abstract class PresetColor with _$PresetColor {
  const factory PresetColor({required String name, required String hex}) = _PresetColor;

  const PresetColor._();

  factory PresetColor.fromJson(Map<String, dynamic> json) => _$PresetColorFromJson(json);
}
