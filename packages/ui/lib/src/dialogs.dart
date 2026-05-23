// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'theme/app_colors.dart';
import 'spacing.dart';
import 'forms.dart';
import 'l10n.dart';

void showAppBottomSheet(BuildContext context, WidgetBuilder builder, {bool useSafeArea = false}) {
  final cs = Theme.of(context).colorScheme;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: useSafeArea,
    backgroundColor: cs.surfaceContainerHigh,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: builder,
  );
}

Future<bool?> showConfirmDelete(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final cs = Theme.of(context).colorScheme;
  return showDialog<bool>(
    context: context,
    builder: (ctx2) => AlertDialog(
      backgroundColor: cs.surfaceContainerHigh,
      title: Text(title, style: TextStyle(color: cs.onSurface)),
      content: Text(message, style: TextStyle(color: cs.onSurfaceVariant)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx2, false),
          child: Text(context.l10n.cancel, style: TextStyle(color: cs.onSurfaceVariant)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx2, true),
          child: Text(context.l10n.delete, style: const TextStyle(color: AppColors.expense)),
        ),
      ],
    ),
  );
}

const dialogPadding = EdgeInsets.fromLTRB(20, 20, 20, 24);

const dialogTitleStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);

Widget buildInfoDialogBody(BuildContext context, String title, List<Widget> children) {
  return SingleChildScrollView(
    padding: dialogPadding,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: dialogTitleStyle),
        gapH16,
        ...children,
        gapH12,
        formBtn(context, context.l10n.close, outlined: true, onTap: () => Navigator.pop(context)),
      ],
    ),
  );
}
