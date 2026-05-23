// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'theme/app_colors.dart';

void showStyledSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: AppColors.accent,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
    ),
  );
}
