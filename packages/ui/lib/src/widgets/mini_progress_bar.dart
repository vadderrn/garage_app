// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import '../theme/theme_colors_x.dart';

class MiniProgressBar extends StatelessWidget {
  final double fraction;
  final Color color;
  const MiniProgressBar({super.key, required this.fraction, required this.color});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Container(
        height: 6,
        color: context.bgSecondary,
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: fraction,
          child: Container(
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
          ),
        ),
      ),
    );
  }
}
