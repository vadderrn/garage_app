// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:backend/backend.dart';
import 'package:ui/ui.dart';
import '../../providers/providers.dart';

void showBreakdownDialog(BuildContext context, CarDetailNotifier detail) {
  final cs = Theme.of(context).colorScheme;
  final currency = context.read<SettingsNotifier>().currency;
  final sortedCats = detail.categoryTotals.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final maxCost = sortedCats.isNotEmpty ? sortedCats.first.value : 1;

  Widget buildContent(BuildContext ctx) {
    final children = <Widget>[
      ..._buildCategoryBars(
        sortedCats,
        categories,
        detail.totalSpent,
        maxCost,
        currency,
        cs,
        context,
      ),
      gapH8,
      Text(
        '${context.l10n.totalLabel} ${formatCurrency(detail.totalSpent, currency)}',
        style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
      ),
    ];

    return buildInfoDialogBody(context, context.l10n.spendingByCategory, children);
  }

  showAppBottomSheet(context, (ctx) => buildContent(ctx));
}

List<Widget> _buildCategoryBars(
  List<MapEntry<String, int>> sortedCats,
  Map<String, CategoryInfo> categories,
  int totalSpent,
  int maxCost,
  String currency,
  ColorScheme cs,
  BuildContext context,
) {
  return sortedCats.map((e) {
    final cat = categories[e.key];
    final pct = totalSpent > 0 ? (e.value / totalSpent * 100).round() : 0;
    final icon = SizedBox(
      width: 28,
      child: Text(
        cat?.icon ?? '\u{1F4CB}',
        style: const TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
    final label = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            catLabel(context.l10n, e.key),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          gapH4,
          MiniProgressBar(fraction: e.value / maxCost, color: cat?.color ?? cs.onSurfaceVariant),
        ],
      ),
    );
    final cost = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          formatCurrency(e.value, currency),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        Text('$pct%', style: context.textSmall),
      ],
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [icon, gapW10, label, gapW10, cost]),
    );
  }).toList();
}
