// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:backend/backend.dart';

import '../l10n.dart';
import '../spacing.dart';

import '../theme/app_colors.dart';
import '../theme/theme_colors_x.dart';
import 'card_wrapper.dart';
import 'color_dot.dart';

class CarCard extends StatelessWidget {
  final Car car;
  final VoidCallback onTap;
  final String currency;
  final String distanceUnit;
  final double? width;

  const CarCard({
    super.key,
    required this.car,
    required this.onTap,
    required this.currency,
    required this.distanceUnit,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
    final priceStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColors.accent,
    );
    final titleWidget = Flexible(child: Text('${car.make} ${car.model}', style: titleStyle));
    final header = Row(
      children: [
        Expanded(
          child: Row(
            children: [
              ColorDot(color: car.color),
              gapW8,
              titleWidget,
            ],
          ),
        ),
        Text(formatCurrency(car.price, currency), style: priceStyle),
      ],
    );
    final plateDeco = BoxDecoration(
      color: context.bgSecondary,
      border: Border.all(color: context.cardBorder),
      borderRadius: BorderRadius.circular(6),
    );
    final plate = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: plateDeco,
      child: Text(car.plate, style: context.textSmall, overflow: TextOverflow.ellipsis),
    );
    final infoRow = Row(
      children: [
        _infoColumn(context.l10n.year, car.year.toString(), context: context),
        gapW12,
        _infoColumn(
          context.l10n.mileage,
          formatDistance(car.mileage, distanceUnit, context.l10n),
          context: context,
        ),
        gapW12,
        _infoColumn(
          context.l10n.totalSpentLabel,
          formatCurrency(car.totalSpent, currency),
          isExpense: true,
          context: context,
        ),
      ],
    );
    final content = Padding(
      padding: const EdgeInsets.fromLTRB(16, 3, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [header, gapH2, plate, gapH4, infoRow],
      ),
    );
    final topBar = Container(height: 3, decoration: BoxDecoration(color: car.color));
    final card = CardWrapper(
      onTap: onTap,
      borderRadius: 16,
      padding: EdgeInsets.zero,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [topBar, content]),
    );
    return width != null ? SizedBox(width: width, child: card) : card;
  }

  Widget _infoColumn(
    String label,
    String value, {
    bool isExpense = false,
    required BuildContext context,
  }) {
    final valueStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: isExpense ? AppColors.expense : context.textPrimary,
    );
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.labelSmall),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }
}
