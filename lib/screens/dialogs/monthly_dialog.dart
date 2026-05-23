// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:backend/backend.dart';
import 'package:ui/ui.dart';
import '../../providers/providers.dart';

Future<void> showMonthlyDialog(BuildContext context, Car car, CarDetailNotifier detail) async {
  final cs = Theme.of(context).colorScheme;
  final repo = context.read<CarRepository>();
  final notifier = context.read<SettingsNotifier>();
  final currency = notifier.currency;
  final l10n = context.l10n;

  final monthlyData = <MonthlyEntry>[];
  for (var i = 3; i >= 0; i--) {
    final now = DateTime.now();
    final y = resolveYearOffset(i, now);
    final m = resolveMonthOffset(i, now) + 1;
    final spent = await repo.getMonthYearSpending(car.id, y, m);
    final count = await repo.getMonthYearWorkCount(car.id, y, m);
    monthlyData.add(MonthlyEntry(name: _getMonthName(l10n, i), spent: spent, count: count));
  }
  final maxSpent = monthlyData.fold(1, (a, b) => a > b.spent ? a : b.spent);
  final curr = monthlyData[3], prev = monthlyData[2];
  final change = prev.spent > 0
      ? ((curr.spent - prev.spent) / prev.spent * 100).round()
      : (curr.spent > 0 ? 100 : 0);

  if (!context.mounted) return;

  Widget buildContent(BuildContext ctx) {
    final changeIcon = Text(
      change > 0
          ? '\u{2191}'
          : change < 0
          ? '\u{2193}'
          : '\u{2192}',
      style: TextStyle(
        fontSize: 20,
        color: change > 0
            ? AppColors.expense
            : change < 0
            ? AppColors.accent
            : cs.onSurfaceVariant,
      ),
    );
    final changeLabel = Flexible(
      child: Text(
        change == 0
            ? context.l10n.noChange
            : '${change.abs()}% ${change > 0 ? context.l10n.more : context.l10n.less} ${context.l10n.vsPrevMonth}',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: change > 0
              ? AppColors.expense
              : change < 0
              ? AppColors.accent
              : cs.onSurfaceVariant,
        ),
      ),
    );
    final summary = SummaryCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [changeIcon, gapW8, changeLabel],
      ),
    );

    final children = <Widget>[
      ..._buildMonthlyEntries(monthlyData, currency, cs, maxSpent, context),
      gapH8,
      summary,
    ];

    return buildInfoDialogBody(context, context.l10n.monthlySpending, children);
  }

  showAppBottomSheet(context, (ctx) => buildContent(ctx));
}

List<Widget> _buildMonthlyEntries(
  List<MonthlyEntry> data,
  String currency,
  ColorScheme cs,
  int maxSpent,
  BuildContext context,
) {
  return data.reversed.map((m) {
    final isNow = m == data.reversed.last;
    final name = Flexible(
      child: Text(
        '${m.name}${isNow ? ' (${context.l10n.now})' : ''}',
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        overflow: TextOverflow.ellipsis,
      ),
    );
    final amount = Text(
      formatCurrency(m.spent, currency),
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
    final count = Text(
      '${m.count} ${m.count == 1 ? context.l10n.record : context.l10n.workRecords}',
      style: context.textSmall,
    );
    final row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [name, gapW8, amount],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          row,
          gapH4,
          count,
          gapH4,
          MiniProgressBar(fraction: m.spent / maxSpent, color: AppColors.accent),
        ],
      ),
    );
  }).toList();
}

String _getMonthName(L10n l10n, int offset) {
  final now = DateTime.now();
  final y = resolveYearOffset(offset, now);
  final m = resolveMonthOffset(offset, now);
  return '${monthName(l10n, m)} $y';
}
