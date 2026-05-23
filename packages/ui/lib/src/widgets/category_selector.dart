// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:backend/backend.dart';

import '../l10n.dart';
import '../theme/app_colors.dart';
import '../models.dart';
import '../spacing.dart';

class CategorySelector extends StatelessWidget {
  final Map<String, CategoryInfo> categories;
  final String selected;
  final ValueChanged<String> onSelect;
  const CategorySelector({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = MediaQuery.of(context).size.width < 600 ? 3 : 5;
        final itemWidth = (constraints.maxWidth - 8 * (cols - 1)) / cols;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.entries.map((e) => _buildItem(context, e, itemWidth, cs)).toList(),
        );
      },
    );
  }

  Widget _buildItem(
    BuildContext context,
    MapEntry<String, CategoryInfo> e,
    double itemWidth,
    ColorScheme cs,
  ) {
    final isSel = e.key == selected;
    final deco = BoxDecoration(
      color: isSel ? AppColors.accent.withValues(alpha: 0.1) : cs.surface,
      border: Border.all(color: isSel ? AppColors.accent : cs.outlineVariant),
      borderRadius: BorderRadius.circular(12),
    );
    final txtStyle = TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w500,
      color: isSel ? AppColors.accent : cs.onSurfaceVariant,
    );
    return SizedBox(
      width: itemWidth,
      child: GestureDetector(
        onTap: () => onSelect(e.key),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: deco,
          child: Column(
            children: [
              Text(e.value.icon, style: const TextStyle(fontSize: 18)),
              gapH2,
              Text(
                catLabel(context.l10n, e.key),
                style: txtStyle,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
