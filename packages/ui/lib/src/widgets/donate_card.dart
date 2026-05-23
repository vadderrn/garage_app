// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import '../spacing.dart';
import '../theme/app_colors.dart';
import '../theme/theme_colors_x.dart';
import 'card_wrapper.dart';

class DonateCard extends StatelessWidget {
  final String icon;
  final String amount;
  final String desc;
  final bool featured;
  final VoidCallback onTap;

  const DonateCard({
    super.key,
    required this.icon,
    required this.amount,
    required this.desc,
    this.featured = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = CardWrapper(
      onTap: onTap,
      borderRadius: 14,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      backgroundColor: featured ? AppColors.accent.withValues(alpha: 0.1) : null,
      border: Border.all(color: featured ? AppColors.accent : context.cardBorder),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(icon, style: const TextStyle(fontSize: 22), textAlign: TextAlign.center),
          gapH6,
          Text(
            amount,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            desc,
            style: TextStyle(fontSize: 10, color: context.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    if (!featured) return card;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        card,
        const Positioned(top: -8, left: 0, right: 0, child: Center(child: _PopularBadge())),
      ],
    );
  }
}

class _PopularBadge extends StatelessWidget {
  const _PopularBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(8)),
      child: const Text(
        'Popular',
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white),
      ),
    );
  }
}

class DonateMethod extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  const DonateMethod({super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            icon,
            gapH4,
            Text(label, style: TextStyle(fontSize: 10, color: context.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class GitHubIcon extends StatelessWidget {
  final double size;
  final Color color;
  const GitHubIcon({super.key, this.size = 24, this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GitHubPainter(color)),
    );
  }
}

class _GitHubPainter extends CustomPainter {
  final Color color;
  const _GitHubPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(12, 0)
      ..cubicTo(5.37, 0, 0, 5.37, 0, 12)
      ..cubicTo(0, 17.31, 3.435, 21.795, 8.205, 23.385)
      ..cubicTo(8.805, 23.49, 9.03, 23.13, 9.03, 22.815)
      ..cubicTo(9.03, 22.53, 9.015, 21.585, 9.015, 20.58)
      ..cubicTo(6, 21.135, 5.22, 19.845, 4.98, 19.17)
      ..cubicTo(4.845, 18.825, 4.26, 17.76, 3.75, 17.475)
      ..cubicTo(3.33, 17.25, 2.73, 16.695, 3.735, 16.68)
      ..cubicTo(4.68, 16.665, 5.355, 17.55, 5.58, 17.91)
      ..cubicTo(6.66, 19.725, 8.385, 19.215, 9.075, 18.9)
      ..cubicTo(9.18, 18.12, 9.495, 17.595, 9.84, 17.295)
      ..cubicTo(7.17, 16.995, 4.38, 15.96, 4.38, 11.37)
      ..cubicTo(4.38, 10.065, 4.845, 8.985, 5.61, 8.145)
      ..cubicTo(5.49, 7.845, 5.07, 6.615, 5.73, 4.965)
      ..cubicTo(5.73, 4.965, 6.735, 4.65, 9.03, 6.195)
      ..cubicTo(9.99, 5.925, 11.01, 5.79, 12.03, 5.79)
      ..cubicTo(13.05, 5.79, 14.07, 5.925, 15.03, 6.195)
      ..cubicTo(17.325, 4.635, 18.33, 4.965, 18.33, 4.965)
      ..cubicTo(18.99, 6.615, 18.57, 7.845, 18.45, 8.145)
      ..cubicTo(19.215, 8.985, 19.68, 10.05, 19.68, 11.37)
      ..cubicTo(19.68, 15.975, 16.875, 16.995, 14.205, 17.295)
      ..cubicTo(14.64, 17.67, 15.015, 18.39, 15.015, 19.515)
      ..cubicTo(15.015, 21.12, 15, 22.41, 15, 22.815)
      ..cubicTo(15, 23.13, 15.225, 23.49, 15.825, 23.385)
      ..cubicTo(20.565, 21.795, 24, 17.31, 24, 12)
      ..cubicTo(24, 5.37, 18.63, 0, 12, 0)
      ..close();
    final scale = size.width / 24;
    canvas.scale(scale, scale);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _GitHubPainter old) => old.color != color;
}
