// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:backend/backend.dart';
import 'package:ui/ui.dart';
import '../../providers/providers.dart';

void showOilHistoryDialog(
  BuildContext context,
  Car car,
  CarDetailNotifier detail,
  String distanceUnit,
) {
  final cs = Theme.of(context).colorScheme;
  final currency = context.read<SettingsNotifier>().currency;
  final oilWorks = detail.works.where((w) => isOilChange(w.description)).toList();
  final status = car.oilLife > 50
      ? 'good'
      : car.oilLife > 20
      ? 'warning'
      : 'danger';
  final statusColor = status == 'good'
      ? AppColors.oilGreen
      : status == 'warning'
      ? AppColors.oilYellow
      : AppColors.oilRed;

  Widget buildContent(BuildContext ctx) {
    final oilLifeCol = statLabelColumn(
      context,
      context.l10n.oilLife,
      '${car.oilLife}%',
      valueStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: statusColor),
    );
    final sinceCol = statLabelColumn(
      context,
      context.l10n.sinceChange,
      formatDistance(car.oilKm, distanceUnit, context.l10n),
    );
    final maxCol = statLabelColumn(
      context,
      context.l10n.max,
      formatDistance(car.oilMax, distanceUnit, context.l10n),
      crossAxisAlignment: CrossAxisAlignment.end,
    );

    final summary = SummaryCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [oilLifeCol, sinceCol, maxCol],
      ),
    );

    final children = <Widget>[
      summary,
      gapH12,
      if (oilWorks.isEmpty)
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(context.l10n.noOilRecords, style: TextStyle(color: cs.onSurfaceVariant)),
        )
      else ...[
        Text(
          '${oilWorks.length} ${oilWorks.length > 1 ? context.l10n.workRecords : context.l10n.record}',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        gapH8,
        ...oilWorks.map((w) => _buildOilWorkItem(w, cs, currency)),
      ],
    ];

    return buildInfoDialogBody(context, context.l10n.oilChangeHistory, children);
  }

  showAppBottomSheet(context, (ctx) => buildContent(ctx));
}

Widget _buildOilWorkItem(WorkRecord w, ColorScheme cs, String currency) {
  final icon = const SizedBox(
    width: 28,
    child: Text('\u{1F527}', style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
  );
  final desc = Expanded(child: Text(w.description, style: const TextStyle(fontSize: 14)));
  final expenseStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.expense,
  );
  final amount = Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Text('-${formatCurrency(w.cost, currency)}', style: expenseStyle),
      Text(w.date, style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
    ],
  );

  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [icon, gapW10, desc, gapW8, amount]),
  );
}
