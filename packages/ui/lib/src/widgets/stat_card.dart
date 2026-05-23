// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import '../spacing.dart';
import '../theme/theme_colors_x.dart';
import 'card_wrapper.dart';

class StatCard extends StatelessWidget {
  final String label;
  final Widget value;
  final Widget? subtitle;
  final VoidCallback? onTap;

  const StatCard({super.key, required this.label, required this.value, this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(label.toUpperCase(), style: context.labelSmall)),
              if (onTap != null)
                Text('\u{203A}', style: TextStyle(color: context.textSecondary, fontSize: 14)),
            ],
          ),
          gapH4,
          value,
          if (subtitle != null) ...[gapH2, subtitle!],
        ],
      ),
    );
  }
}
