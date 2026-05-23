// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:backend/backend.dart';
import '../models.dart';

Color parseHex(String hex) => Color(int.parse(hex.replaceFirst('#', '0xff')));

extension CarColorX on Car {
  Color get color => parseHex(colorHex);
}

extension CategoryInfoColorX on CategoryInfo {
  Color get color => Color(colorValue);
}

extension PresetColorColorX on PresetColor {
  Color get color => parseHex(hex);
}

extension ThemeColorsX on BuildContext {
  Color get bgPrimary => Theme.of(this).scaffoldBackgroundColor;
  Color get bgSecondary => Theme.of(this).colorScheme.surface;
  Color get textPrimary => Theme.of(this).colorScheme.onSurface;
  Color get textSecondary => Theme.of(this).colorScheme.onSurfaceVariant;
  Color get cardBg => Theme.of(this).colorScheme.surface;
  Color get cardBorder => Theme.of(this).colorScheme.outlineVariant;
  Color get inputBg => Theme.of(this).colorScheme.surfaceContainerHighest;
  Color get modalBg => Theme.of(this).colorScheme.surfaceContainerHigh;
  TextStyle get labelSmall => TextStyle(fontSize: 10, letterSpacing: 0.5, color: textSecondary);
  TextStyle get textSmall => TextStyle(fontSize: 11, color: textSecondary);
}

// L10nX is in packages/ui/lib/src/l10n.dart,
// because AppLocalizations is generated in the app package.
