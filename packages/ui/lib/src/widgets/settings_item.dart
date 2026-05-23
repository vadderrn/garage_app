// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import '../spacing.dart';
import '../theme/theme_colors_x.dart';
import 'card_wrapper.dart';

class SettingsItem extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      onTap: onTap,
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          gapW10,
          Expanded(child: Text(title, style: const TextStyle(fontSize: 15))),
          Text(value, style: TextStyle(fontSize: 14, color: context.textSecondary)),
          gapW8,
          Text('\u{203A}', style: TextStyle(color: context.textSecondary, fontSize: 18)),
        ],
      ),
    );
  }
}
