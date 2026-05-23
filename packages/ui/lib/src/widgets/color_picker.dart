// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/theme_colors_x.dart';
import '../models.dart';

class ColorPicker extends StatelessWidget {
  final List<PresetColor> colors;
  final String selected;
  final ValueChanged<String> onSelect;

  const ColorPicker({
    super.key,
    required this.colors,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final circles = colors.map(_buildCircle).toList();
    return Wrap(spacing: 8, runSpacing: 8, children: circles);
  }

  Color _borderColor(String hex) {
    return hex == '#f5f5f5' || hex == '#ffd700' ? const Color(0xFF555555) : Colors.transparent;
  }

  Widget _buildCircle(PresetColor pc) {
    final isSelected = pc.hex == selected;
    final border = Border.all(
      color: isSelected ? AppColors.accent : _borderColor(pc.hex),
      width: isSelected ? 2 : 1,
    );
    final shadow = isSelected
        ? [BoxShadow(color: AppColors.accent.withValues(alpha: 0.3), blurRadius: 4)]
        : null;
    final deco = BoxDecoration(
      color: pc.color,
      shape: BoxShape.circle,
      border: border,
      boxShadow: shadow,
    );
    return GestureDetector(
      onTap: () => onSelect(pc.hex),
      child: Container(width: 32, height: 32, decoration: deco),
    );
  }
}
