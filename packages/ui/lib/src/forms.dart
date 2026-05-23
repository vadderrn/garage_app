// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:backend/backend.dart';

import 'spacing.dart';
import 'l10n.dart';

import 'theme/app_colors.dart';
import 'widgets/card_wrapper.dart';

class FormLabel extends StatelessWidget {
  final String label;
  const FormLabel(this.label, {super.key});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, letterSpacing: 0.5, color: cs.onSurfaceVariant),
      ),
    );
  }
}

class FormFieldGroup extends StatelessWidget {
  final String label;
  final Widget field;
  final String? errorText;

  const FormFieldGroup({super.key, required this.label, required this.field, this.errorText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormLabel(label),
          gapH6,
          field,
          if (errorText != null) _buildError(context),
          gapH8,
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 4),
      child: Text(
        errorText!,
        style: const TextStyle(color: AppColors.expense, fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }
}

Widget formField(
  BuildContext context,
  String label,
  TextEditingController ctrl, {
  String? hint,
  TextInputType? keyboardType,
  String? errorText,
  ValueChanged<String>? onChanged,
}) {
  final cs = Theme.of(context).colorScheme;
  final inputDeco = InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: cs.onSurfaceVariant),
    border: InputBorder.none,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  );
  final field = Container(
    decoration: BoxDecoration(
      color: cs.surfaceContainerHighest,
      border: Border.all(color: errorText != null ? AppColors.expense : cs.outlineVariant),
      borderRadius: BorderRadius.circular(10),
    ),
    child: TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: TextStyle(color: cs.onSurface, fontSize: 15),
      decoration: inputDeco,
    ),
  );
  return FormFieldGroup(label: label, errorText: errorText, field: field);
}

Widget formBtn(
  BuildContext context,
  String label, {
  bool outlined = false,
  required VoidCallback onTap,
}) {
  final cs = Theme.of(context).colorScheme;
  final border = outlined
      ? Border.all(color: cs.outlineVariant)
      : Border.all(width: 0, color: Colors.transparent);
  final txtStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: outlined ? cs.onSurface : Colors.white,
  );
  return CardWrapper(
    onTap: onTap,
    padding: const EdgeInsets.symmetric(vertical: 14),
    backgroundColor: outlined ? Colors.transparent : AppColors.accent.withValues(alpha: 0.5),
    border: border,
    child: Center(child: Text(label, style: txtStyle)),
  );
}

Widget dangerBtn(
  BuildContext context, {
  required String text,
  required VoidCallback onTap,
  double fontSize = 18,
}) {
  return CardWrapper(
    onTap: onTap,
    borderRadius: 8,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    backgroundColor: Colors.transparent,
    border: Border.all(color: AppColors.expense.withValues(alpha: 0.3)),
    child: Center(
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize, color: AppColors.expense),
      ),
    ),
  );
}

Widget circularBtn(
  BuildContext context, {
  required String text,
  required VoidCallback onTap,
  double fontSize = 18,
}) {
  final cs = Theme.of(context).colorScheme;
  final txtStyle = TextStyle(
    fontSize: fontSize,
    height: 1,
    color: cs.onSurface,
    leadingDistribution: TextLeadingDistribution.proportional,
  );
  return SizedBox(
    width: 36,
    height: 36,
    child: CardWrapper(
      onTap: onTap,
      circular: true,
      padding: EdgeInsets.zero,
      backgroundColor: cs.surface,
      border: Border.all(color: cs.outlineVariant),
      child: Center(child: Text(text, style: txtStyle)),
    ),
  );
}

Widget buildDateField(
  BuildContext context,
  String label,
  TextEditingController ctrl, {
  String? errorText,
  VoidCallback? onChanged,
}) {
  final cs = Theme.of(context).colorScheme;
  final deco = BoxDecoration(
    color: cs.surfaceContainerHighest,
    border: Border.all(color: errorText != null ? AppColors.expense : cs.outlineVariant),
    borderRadius: BorderRadius.circular(10),
  );
  final inputDeco = InputDecoration(
    hintText: '2026-04-12',
    hintStyle: TextStyle(color: cs.onSurfaceVariant),
    border: InputBorder.none,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    suffixIcon: Icon(Icons.calendar_today, size: 18, color: cs.onSurfaceVariant),
  );
  final field = GestureDetector(
    onTap: onChanged,
    child: Container(
      decoration: deco,
      child: AbsorbPointer(
        child: TextField(
          controller: ctrl,
          style: TextStyle(color: cs.onSurface, fontSize: 15),
          decoration: inputDeco,
        ),
      ),
    ),
  );
  return FormFieldGroup(label: label, errorText: errorText, field: field);
}

Future<void> pickDate(BuildContext ctx, TextEditingController ctrl) async {
  final initial = DateTime.tryParse(ctrl.text) ?? DateTime.now();
  final isDark = Theme.of(ctx).brightness == Brightness.dark;
  final bg = isDark ? const Color(0xFF1c1c1e) : const Color(0xFFf0f0f0);
  final fg = isDark ? Colors.white : Colors.black;
  final picked = await showDatePicker(
    context: ctx,
    initialDate: initial,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    builder: (ctx, child) => _buildDatePickerTheme(ctx, child!, isDark, bg, fg),
  );
  if (picked != null) {
    ctrl.text =
        '${picked.year}-${formatMonth(picked.month)}-${picked.day.toString().padLeft(2, '0')}';
  }
}

Theme _buildDatePickerTheme(BuildContext ctx, Widget child, bool isDark, Color bg, Color fg) {
  final confirmStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(AppColors.accent),
    foregroundColor: WidgetStateProperty.all(Colors.white),
    padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
  );
  final cancelShape = WidgetStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: isDark ? const Color(0xFF333333) : const Color(0xFFdddddd)),
    ),
  );
  final cancelStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Colors.transparent),
    foregroundColor: WidgetStateProperty.all(fg),
    padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
    shape: cancelShape,
    textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
  );
  final fgProp = WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.selected)) return Colors.white;
    return fg;
  });
  final bgProp = WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.selected)) return AppColors.accent;
    return null;
  });
  final inputDeco = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.accent),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.accent, width: 2),
    ),
  );
  final dpt = DatePickerThemeData(
    backgroundColor: bg,
    surfaceTintColor: Colors.transparent,
    headerBackgroundColor: bg,
    headerForegroundColor: fg,
    confirmButtonStyle: confirmStyle,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    cancelButtonStyle: cancelStyle,
    todayBackgroundColor: WidgetStateProperty.all(AppColors.accent.withValues(alpha: 0.2)),
    todayForegroundColor: WidgetStateProperty.all(fg),
    dayForegroundColor: fgProp,
    dayBackgroundColor: bgProp,
    yearForegroundColor: fgProp,
    yearBackgroundColor: bgProp,
    inputDecorationTheme: inputDeco,
  );
  return Theme(
    data: Theme.of(ctx).copyWith(
      colorScheme: Theme.of(ctx).colorScheme.copyWith(primary: AppColors.accent),
      datePickerTheme: dpt,
    ),
    child: child,
  );
}

Widget formActionRow(
  BuildContext context, {
  required bool isEdit,
  Widget? deleteBtn,
  required VoidCallback onCancel,
  required VoidCallback onSave,
}) {
  return Row(
    children: [
      if (isEdit && deleteBtn != null) ...[deleteBtn, gapW10],
      Expanded(child: formBtn(context, context.l10n.cancel, outlined: true, onTap: onCancel)),
      gapW10,
      Expanded(child: formBtn(context, context.l10n.save, onTap: onSave)),
    ],
  );
}

Widget buildFormDialogWrapper(BuildContext context, List<Widget> children) {
  return Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    ),
  );
}

class ValidationRule {
  final String key;
  final TextEditingController controller;
  final String? Function(String value, BuildContext context) validator;

  const ValidationRule(this.key, this.controller, this.validator);
}

Map<String, String> validateFields(BuildContext context, List<ValidationRule> rules) {
  final errors = <String, String>{};
  for (final r in rules) {
    final err = r.validator(r.controller.text.trim(), context);
    if (err != null) errors[r.key] = err;
  }
  return errors;
}
