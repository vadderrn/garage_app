// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import '../theme/theme_colors_x.dart';

class CardWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Border? border;
  final bool circular;

  const CardWrapper({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = 12,
    this.backgroundColor,
    this.border,
    this.circular = false,
  });

  @override
  Widget build(BuildContext context) {
    final inner = Padding(padding: padding, child: child);
    final tapWidget = onTap != null
        ? InkWell(
            onTap: onTap,
            borderRadius: circular ? null : BorderRadius.circular(borderRadius),
            customBorder: circular ? const CircleBorder() : null,
            child: inner,
          )
        : inner;
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? context.cardBg,
        border: border ?? Border.all(color: context.cardBorder),
        borderRadius: circular ? null : BorderRadius.circular(borderRadius),
        shape: circular ? BoxShape.circle : BoxShape.rectangle,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(type: MaterialType.transparency, child: tapWidget),
    );
  }
}
