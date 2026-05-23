// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:backend/backend.dart';
import '../l10n.dart';
import '../spacing.dart';
import '../theme/app_colors.dart';
import '../theme/theme_colors_x.dart';
import 'card_wrapper.dart';
import 'mini_progress_bar.dart';

class OilLifeCard extends StatelessWidget {
  final int oilLife;
  final int oilKm;
  final int oilMax;
  final String distanceUnit;
  const OilLifeCard({
    super.key,
    required this.oilLife,
    required this.oilKm,
    required this.oilMax,
    required this.distanceUnit,
  });

  Color get _barColor => oilLife > 50
      ? AppColors.oilGreen
      : oilLife > 20
      ? AppColors.oilYellow
      : AppColors.oilRed;

  @override
  Widget build(BuildContext context) {
    final statusText = Text(
      '$oilLife% ${oilLife > 50
          ? context.l10n.good
          : oilLife > 20
          ? context.l10n.dueSoon
          : context.l10n.overdue}',
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _barColor),
    );
    return CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(context.l10n.oilLife, style: context.labelSmall),
              const Spacer(),
              statusText,
            ],
          ),
          gapH6,
          MiniProgressBar(fraction: oilLife / 100, color: _barColor),
          gapH4,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${formatDistance(oilKm, distanceUnit, context.l10n)} ${context.l10n.sinceChangeKm}',
                style: TextStyle(fontSize: 10, color: context.textSecondary),
              ),
              Text(
                '${context.l10n.max} ${formatDistance(oilMax, distanceUnit, context.l10n)}',
                style: TextStyle(fontSize: 10, color: context.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
