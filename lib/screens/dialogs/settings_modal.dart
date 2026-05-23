// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:backend/backend.dart';
import 'package:ui/ui.dart';

void showSettingsModal(
  BuildContext context, {
  required String title,
  required List<SettingsOption> options,
  required String current,
  required ValueChanged<String> onSelected,
}) {
  final cs = Theme.of(context).colorScheme;

  Widget buildOption(SettingsOption opt, BuildContext ctx) {
    final isCurrent = opt.value == current;
    final style = TextStyle(
      fontSize: 15,
      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
      color: isCurrent ? Colors.white : cs.onSurface,
    );
    final label = Text(opt.label, style: style);
    final deco = BoxDecoration(
      color: isCurrent ? AppColors.accent : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
    );
    final check = isCurrent
        ? const Text(
            '\u{2713}',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          )
        : null;

    return GestureDetector(
      onTap: () {
        onSelected(opt.value);
        Navigator.pop(ctx);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: deco,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [label, ?check]),
      ),
    );
  }

  Widget buildContent(BuildContext ctx) {
    final body = <Widget>[
      Text(title, style: dialogTitleStyle),
      gapH16,
      ...options.map((opt) => buildOption(opt, ctx)),
      gapH8,
      formBtn(context, context.l10n.cancel, outlined: true, onTap: () => Navigator.pop(ctx)),
    ];

    return Padding(
      padding: dialogPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: body,
      ),
    );
  }

  showAppBottomSheet(context, (ctx) => buildContent(ctx));
}
