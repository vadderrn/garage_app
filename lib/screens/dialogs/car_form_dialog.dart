// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:backend/backend.dart';
import 'package:ui/ui.dart';
import '../../providers/providers.dart';

void showCarFormDialog(BuildContext context, Car? existing, Future<void> Function(Car) onSave) {
  final isEdit = existing != null;
  final makeCtrl = TextEditingController(text: existing?.make ?? '');
  final modelCtrl = TextEditingController(text: existing?.model ?? '');
  final yearCtrl = TextEditingController(text: existing?.year.toString() ?? '');
  final plateCtrl = TextEditingController(text: existing?.plate ?? '');
  final priceCtrl = TextEditingController(text: existing?.price.toString() ?? '');
  final mileageCtrl = TextEditingController(text: existing?.mileage.toString() ?? '');
  var selectedColor = existing?.colorHex ?? presetColors[4].hex;
  var errors = <String, String?>{};

  Widget buildContent(BuildContext ctx, StateSetter setSheetState) {
    void handleSave() async {
      final errs = _validate(context, makeCtrl, modelCtrl, yearCtrl, priceCtrl, mileageCtrl);
      if (errs.isNotEmpty) {
        setSheetState(() => errors = errs);
        return;
      }
      Navigator.pop(ctx);
      final car = Car(
        id: existing?.id ?? -1,
        make: makeCtrl.text.trim(),
        model: modelCtrl.text.trim(),
        year: int.parse(yearCtrl.text.trim()),
        plate: plateCtrl.text.trim().isEmpty ? (existing?.plate ?? 'N/A') : plateCtrl.text.trim(),
        colorHex: selectedColor,
        price: int.parse(priceCtrl.text.trim()),
        mileage: int.parse(mileageCtrl.text.trim()),
        oilLife: existing?.oilLife ?? 100,
        oilKm: existing?.oilKm ?? 0,
        oilMax: existing?.oilMax ?? 10000,
        works: existing?.works ?? const [],
      );
      await onSave(car);
    }

    final yearField = Expanded(
      child: formField(
        context,
        context.l10n.year,
        yearCtrl,
        hint: '2024',
        keyboardType: TextInputType.number,
        errorText: errors['year'],
        onChanged: (_) => setSheetState(() => errors.remove('year')),
      ),
    );
    final plateField = Expanded(
      child: formField(context, context.l10n.plate, plateCtrl, hint: 'A123BC'),
    );

    final priceField = Expanded(
      child: formField(
        context,
        context.l10n.price,
        priceCtrl,
        hint: '30000',
        keyboardType: TextInputType.number,
        errorText: errors['price'],
        onChanged: (_) => setSheetState(() => errors.remove('price')),
      ),
    );
    final mileageField = Expanded(
      child: formField(
        context,
        context.l10n.mileageForm,
        mileageCtrl,
        hint: '0',
        keyboardType: TextInputType.number,
        errorText: errors['mileage'],
        onChanged: (_) => setSheetState(() => errors.remove('mileage')),
      ),
    );

    final body = <Widget>[
      Text(
        isEdit
            ? '\u{270F}\u{FE0F} ${context.l10n.editCar.substring(3)}'
            : '\u{1F697} ${context.l10n.addCar.substring(2)}',
        style: dialogTitleStyle,
      ),
      gapH16,
      formField(
        context,
        context.l10n.make,
        makeCtrl,
        hint: '${context.l10n.eg} BMW',
        errorText: errors['make'],
        onChanged: (_) => setSheetState(() => errors.remove('make')),
      ),
      formField(
        context,
        context.l10n.model,
        modelCtrl,
        hint: '${context.l10n.eg} X5',
        errorText: errors['model'],
        onChanged: (_) => setSheetState(() => errors.remove('model')),
      ),
      Row(children: [yearField, gapW10, plateField]),
      Row(children: [priceField, gapW10, mileageField]),
      gapH12,
      FormLabel(context.l10n.color),
      gapH6,
      ColorPicker(
        colors: presetColors,
        selected: selectedColor,
        onSelect: (hex) => setSheetState(() => selectedColor = hex),
      ),
      gapH20,
      formActionRow(
        context,
        isEdit: isEdit,
        deleteBtn: dangerBtn(
          context,
          text: '\u{1F5D1}',
          onTap: () => _deleteCar(context, existing!.id, ctx, onSave),
        ),
        onCancel: () => Navigator.pop(ctx),
        onSave: handleSave,
      ),
    ];

    return buildFormDialogWrapper(ctx, body);
  }

  showAppBottomSheet(
    context,
    (ctx) => StatefulBuilder(builder: (ctx, setSheetState) => buildContent(ctx, setSheetState)),
  );
}

Map<String, String> _validate(
  BuildContext context,
  TextEditingController make,
  TextEditingController model,
  TextEditingController year,
  TextEditingController price,
  TextEditingController mileage,
) {
  return validateFields(context, [
    ValidationRule('make', make, (v, ctx) => v.isEmpty ? ctx.l10n.makeRequired : null),
    ValidationRule('model', model, (v, ctx) => v.isEmpty ? ctx.l10n.modelRequired : null),
    ValidationRule('year', year, (v, ctx) {
      final y = int.tryParse(v);
      return v.isEmpty || y == null || y < 1900 || y > 2099 ? ctx.l10n.yearInvalid : null;
    }),
    ValidationRule('price', price, (v, ctx) {
      return v.isEmpty || int.tryParse(v) == null ? ctx.l10n.priceInvalid : null;
    }),
    ValidationRule('mileage', mileage, (v, ctx) {
      return v.isEmpty || int.tryParse(v) == null ? ctx.l10n.mileageInvalid : null;
    }),
  ]);
}

Future<void> _deleteCar(
  BuildContext context,
  int id,
  BuildContext dialogCtx,
  dynamic onSave,
) async {
  final notifier = context.read<CarListNotifier>();
  final confirmed = await showConfirmDelete(
    context,
    title: context.l10n.deleteCar,
    message: context.l10n.confirmDeleteCar(''),
  );
  if (confirmed == true && context.mounted) {
    Navigator.pop(dialogCtx);
    try {
      await notifier.delete(id);
      if (context.mounted) context.read<NavigationNotifier>().pop();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete car: $e')));
      }
    }
  }
}
