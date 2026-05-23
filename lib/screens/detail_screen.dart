// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:backend/backend.dart';
import 'package:ui/ui.dart';
import '../providers/providers.dart';
import 'dialogs/dialogs.dart';

Widget buildInfoBar(
  BuildContext context,
  Car car,
  String currency,
  String distanceUnit, [
  bool isTablet = false,
]) {
  final cs = Theme.of(context).colorScheme;
  final bg = Theme.of(context).scaffoldBackgroundColor;
  final plateDeco = BoxDecoration(
    color: bg,
    border: Border.all(color: cs.outlineVariant),
    borderRadius: BorderRadius.circular(8),
  );
  final plate = Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: plateDeco,
    child: Text(car.plate, style: const TextStyle(fontSize: 13)),
  );
  final distance = Text(
    formatDistance(car.mileage, distanceUnit, context.l10n),
    style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
  );
  final price = Text(
    formatCurrency(car.price, currency),
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.accent),
  );
  final deco = BoxDecoration(
    color: cs.surface,
    border: Border(bottom: BorderSide(color: cs.outlineVariant)),
  );
  final row = Row(children: [plate, gapW16, distance, const Spacer(), price]);

  return Container(
    padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 20, vertical: 12),
    decoration: deco,
    child: row,
  );
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final car = context.watch<CarListNotifier>().selectedCar;
    final detail = context.watch<CarDetailNotifier>();
    final s = context.watch<SettingsNotifier>();
    final currency = s.currency;
    final distanceUnit = s.distanceUnit;
    if (car == null) return const SizedBox();

    final isTablet = context.isTablet;
    final hp = isTablet ? 24.0 : 20.0;
    final serviceTitle = Text(
      '${context.l10n.serviceHistory} (${detail.works.length})',
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );

    return Column(
      children: [
        buildInfoBar(context, car, currency, distanceUnit, isTablet),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildStatCards(context, car, detail, currency, isTablet, hp),
              _buildOilCard(context, car, detail, distanceUnit, hp),
              Padding(padding: EdgeInsets.fromLTRB(hp, 0, hp, 8), child: serviceTitle),
              ..._buildServiceItems(context, car, detail, currency, isTablet, hp),
              gapH8,
            ],
          ),
        ),
        _buildAddWorkBtn(context, car, detail, isTablet, hp),
      ],
    );
  }

  Widget _buildStatCards(
    BuildContext context,
    Car car,
    CarDetailNotifier detail,
    String currency,
    bool isTablet,
    double hp,
  ) {
    final topCat = detail.topCategory;
    final catInfo = topCat != null ? categories[topCat.key] : null;

    final totalSpentVal = Text(
      formatCurrency(detail.totalSpent, currency),
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.expense),
    );
    final avgServiceVal = Text(
      formatCurrency(detail.avgSpent.toInt(), currency),
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
    );
    final lastServiceVal = Text(
      detail.lastService ?? 'N/A',
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
    final topCategoryVal = Text(
      '${catInfo?.icon ?? '\u{1F4CB}'} ${catInfo?.label ?? 'Other'}',
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );

    final avgSub = Text('${detail.works.length} services', style: context.textSmall);
    final topCatSub = topCat != null
        ? Text(
            '${formatCurrency(topCat.value, currency)} \u{00B7} ${context.l10n.topCategoryTap}',
            style: context.textSmall,
          )
        : null;

    Widget makeCard(String label, Widget value, {Widget? subtitle, VoidCallback? onTap}) {
      return Expanded(
        child: StatCard(label: label, value: value, subtitle: subtitle, onTap: onTap),
      );
    }

    if (isTablet) {
      final cards = IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            makeCard(
              context.l10n.totalSpent,
              totalSpentVal,
              onTap: () => showMonthlyDialog(context, car, detail),
            ),
            gapW8,
            makeCard(context.l10n.avgService, avgServiceVal, subtitle: avgSub),
            gapW8,
            makeCard(context.l10n.lastService, lastServiceVal),
            gapW8,
            makeCard(
              context.l10n.topCategory,
              topCategoryVal,
              subtitle: topCatSub,
              onTap: () => showBreakdownDialog(context, detail),
            ),
          ],
        ),
      );

      return Padding(padding: EdgeInsets.fromLTRB(hp, 16, hp, 8), child: cards);
    }

    final row1 = IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          makeCard(
            context.l10n.totalSpent,
            totalSpentVal,
            onTap: () => showMonthlyDialog(context, car, detail),
          ),
          gapW8,
          makeCard(
            context.l10n.avgService,
            avgServiceVal,
            subtitle: Text(
              '${detail.works.length} ${detail.works.length == 1 ? context.l10n.record : context.l10n.workRecords}',
              style: context.textSmall,
            ),
          ),
        ],
      ),
    );
    final row2 = IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          makeCard(context.l10n.lastService, lastServiceVal),
          gapW8,
          makeCard(
            context.l10n.topCategory,
            topCategoryVal,
            onTap: () => showBreakdownDialog(context, detail),
          ),
        ],
      ),
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(hp, 16, hp, 8),
      child: Column(children: [row1, gapH8, row2]),
    );
  }

  Widget _buildOilCard(
    BuildContext context,
    Car car,
    CarDetailNotifier detail,
    String distanceUnit,
    double hp,
  ) {
    final card = InkWell(
      onTap: () => showOilHistoryDialog(context, car, detail, distanceUnit),
      borderRadius: BorderRadius.circular(12),
      child: OilLifeCard(
        oilLife: car.oilLife,
        oilKm: car.oilKm,
        oilMax: car.oilMax,
        distanceUnit: distanceUnit,
      ),
    );

    return Padding(padding: EdgeInsets.fromLTRB(hp, 4, hp, 12), child: card);
  }

  Widget _buildAddWorkBtn(
    BuildContext context,
    Car car,
    CarDetailNotifier detail,
    bool isTablet,
    double hp,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(isTablet ? 24 : 16, 8, isTablet ? 24 : 16, 20),
      child: AddButton(
        label: context.l10n.addWork,
        onTap: () => showWorkFormDialog(context, car.id, null, detail),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    CarDetailNotifier detail,
    WorkRecord w,
    double hp,
    String currency,
    int carId,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(hp, 0, hp, 6),
      child: WorkItem(
        work: w,
        currency: currency,
        onTap: () => showWorkFormDialog(context, carId, w, detail),
      ),
    );
  }

  List<Widget> _buildServiceItems(
    BuildContext context,
    Car car,
    CarDetailNotifier detail,
    String currency,
    bool isTablet,
    double hp,
  ) {
    if (isTablet) {
      Widget buildRow(int i) {
        final idx = detail.works.length - 1 - i * 2;
        final w1 = detail.works[idx];
        final w2 = idx - 1 >= 0 ? detail.works[idx - 1] : null;
        final children = <Widget>[
          Expanded(child: _buildItem(context, detail, w1, hp, currency, car.id)),
          if (w2 != null) ...[
            gapW8,
            Expanded(child: _buildItem(context, detail, w2, hp, currency, car.id)),
          ],
        ];
        return Padding(
          padding: EdgeInsets.fromLTRB(hp, 0, hp, 6),
          child: Row(children: children),
        );
      }

      return List.generate((detail.works.length + 1) ~/ 2, buildRow);
    }
    return detail.works.reversed
        .map((w) => _buildItem(context, detail, w, hp, currency, car.id))
        .toList();
  }
}
