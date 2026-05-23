// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

Widget statLabelColumn(
  BuildContext context,
  String label,
  String value, {
  TextStyle? valueStyle,
  CrossAxisAlignment? crossAxisAlignment,
}) {
  final cs = Theme.of(context).colorScheme;
  return Column(
    crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
      Text(value, style: valueStyle ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    ],
  );
}
