// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFf5f5f5),
    colorScheme: const ColorScheme.light(
      primary: AppColors.accent,
      onSurface: Color(0xFF1a1a1a),
      onSurfaceVariant: Color(0xFF666666),
      outlineVariant: Color(0xFFdddddd),
      surfaceContainerHighest: Color(0xFFeeeeee),
      surfaceContainerHigh: Color(0xFFf0f0f0),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFffffff),
      foregroundColor: Color(0xFF1a1a1a),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Color(0xFF1a1a1a),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    dividerColor: const Color(0xFFdddddd),
  );

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1a1a1a),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      surface: Color(0xFF252525),
      onSurfaceVariant: Color(0xFFb0b0b0),
      outlineVariant: Color(0xFF333333),
      surfaceContainerHighest: Color(0xFF333333),
      surfaceContainerHigh: Color(0xFF1c1c1e),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1a1a1a),
      foregroundColor: Color(0xFFFFFFFF),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    dividerColor: const Color(0xFF333333),
  );
}
