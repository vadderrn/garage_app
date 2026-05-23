// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:backend/backend.dart';

import '../l10n.dart';
import '../data.dart';
import '../spacing.dart';
import '../theme/app_colors.dart';
import '../theme/theme_colors_x.dart';
import 'card_wrapper.dart';

class WorkItem extends StatelessWidget {
  final WorkRecord work;
  final VoidCallback? onTap;
  final String currency;
  const WorkItem({super.key, required this.work, this.onTap, required this.currency});

  @override
  Widget build(BuildContext context) {
    final cat = categories[work.category];
    final icon = Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: (cat?.color ?? context.textSecondary).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: Text(cat?.icon ?? '\u{1F4CB}', style: const TextStyle(fontSize: 18))),
    );
    final desc = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            work.description,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
          gapH2,
          Text(
            '${work.date} \u{00B7} ${cat != null ? catLabel(context.l10n, work.category) : context.l10n.catOther}',
            style: context.textSmall,
          ),
        ],
      ),
    );
    return CardWrapper(
      onTap: onTap,
      child: Row(
        children: [
          icon,
          gapW10,
          desc,
          Text(
            '-${formatCurrency(work.cost, currency)}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.expense,
            ),
          ),
        ],
      ),
    );
  }
}
