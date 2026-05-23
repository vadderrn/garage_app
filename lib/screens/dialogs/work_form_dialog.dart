// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:backend/backend.dart';
import 'package:ui/ui.dart';
import '../../providers/providers.dart';

void showWorkFormDialog(
  BuildContext context,
  int carId,
  WorkRecord? existing,
  CarDetailNotifier detail,
) {
  final isEdit = existing != null;
  final descCtrl = TextEditingController(text: existing?.description ?? '');
  final dateCtrl = TextEditingController(
    text: existing?.date ?? DateTime.now().toIso8601String().substring(0, 10),
  );
  final costCtrl = TextEditingController(text: existing?.cost.toString() ?? '');
  var selectedCat = existing?.category ?? categories.keys.first;
  var errors = <String, String?>{};

  Widget buildContent(BuildContext ctx, StateSetter setSheetState) {
    void onDateChanged() {
      setSheetState(() => errors.remove('date'));
      pickDate(ctx, dateCtrl);
    }

    void onSave() {
      final errs = _validateWork(context, descCtrl, dateCtrl, costCtrl);
      if (errs.isNotEmpty) {
        setSheetState(() => errors = errs);
        return;
      }
      Navigator.pop(ctx);
      final record = WorkRecord(
        id: existing?.id ?? -1,
        description: descCtrl.text.trim(),
        date: dateCtrl.text.trim(),
        cost: int.parse(costCtrl.text.trim()),
        category: selectedCat,
      );
      if (isEdit) {
        detail.updateWork(carId, record);
      } else {
        detail.addWork(carId, record);
      }
    }

    final dateField = Flexible(
      flex: 6,
      child: buildDateField(
        context,
        context.l10n.date,
        dateCtrl,
        errorText: errors['date'],
        onChanged: onDateChanged,
      ),
    );
    final costField = Flexible(
      flex: 4,
      child: formField(
        context,
        context.l10n.cost,
        costCtrl,
        hint: '0',
        keyboardType: TextInputType.number,
        errorText: errors['cost'],
        onChanged: (_) => setSheetState(() => errors.remove('cost')),
      ),
    );

    final body = <Widget>[
      Text(isEdit ? context.l10n.editWork : context.l10n.addWork, style: dialogTitleStyle),
      gapH16,
      formField(
        context,
        context.l10n.description,
        descCtrl,
        hint: context.l10n.workHint,
        errorText: errors['desc'],
        onChanged: (_) => setSheetState(() => errors.remove('desc')),
      ),
      Row(children: [dateField, gapW10, costField]),
      gapH12,
      FormLabel(context.l10n.category),
      gapH8,
      CategorySelector(
        categories: categories,
        selected: selectedCat,
        onSelect: (key) => setSheetState(() => selectedCat = key),
      ),
      gapH20,
      formActionRow(
        context,
        isEdit: isEdit,
        deleteBtn: dangerBtn(
          context,
          text: '\u{1F5D1}',
          onTap: () => _deleteWork(context, carId, existing!.id, ctx, detail),
        ),
        onCancel: () => Navigator.pop(ctx),
        onSave: onSave,
      ),
    ];

    return buildFormDialogWrapper(ctx, body);
  }

  showAppBottomSheet(
    context,
    (ctx) => StatefulBuilder(builder: (ctx, setSheetState) => buildContent(ctx, setSheetState)),
  );
}

Map<String, String> _validateWork(
  BuildContext context,
  TextEditingController desc,
  TextEditingController date,
  TextEditingController cost,
) {
  return validateFields(context, [
    ValidationRule('desc', desc, (v, ctx) => v.isEmpty ? ctx.l10n.descRequired : null),
    ValidationRule('date', date, (v, ctx) => v.isEmpty ? ctx.l10n.dateRequired : null),
    ValidationRule('cost', cost, (v, ctx) {
      final c = int.tryParse(v);
      return v.isEmpty || c == null || c <= 0 ? ctx.l10n.costInvalid : null;
    }),
  ]);
}

Future<void> _deleteWork(
  BuildContext context,
  int carId,
  int workId,
  BuildContext dialogCtx,
  CarDetailNotifier detail,
) async {
  final confirmed = await showConfirmDelete(
    context,
    title: context.l10n.deleteWork,
    message: context.l10n.confirmDeleteWork,
  );
  if (confirmed == true && context.mounted) {
    Navigator.pop(dialogCtx);
    await detail.deleteWork(carId, workId);
  }
}
