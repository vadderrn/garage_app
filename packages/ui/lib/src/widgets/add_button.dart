// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'card_wrapper.dart';

class AddButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const AddButton({super.key, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: CardWrapper(
        onTap: onTap,
        borderRadius: 16,
        padding: const EdgeInsets.all(16),
        backgroundColor: Colors.transparent,
        border: Border.all(color: cs.outlineVariant, width: 2),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: cs.onSurfaceVariant),
        ),
      ),
    );
  }
}
