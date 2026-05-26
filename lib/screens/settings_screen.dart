// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:backend/backend.dart';
import 'package:ui/ui.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/providers.dart';
import 'dialogs/dialogs.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SettingsNotifier>();
    final s = notifier.settings;
    final repo = context.read<CarRepository>();
    final isTablet = context.isTablet;
    final pad = isTablet ? 24.0 : 16.0;
    final prefs = _buildPrefs(context, notifier, s);

    return ListView(
      key: const Key('settings_list'),
      padding: EdgeInsets.fromLTRB(pad, 2, pad, 2),
      children: [
        if (isTablet)
          _buildTabletSettings(context, prefs)
        else ...[
          FormLabel(context.l10n.preferences),
          gapH4,
          ...prefs.expand((p) => [p, gapH4]),
        ],
        gapH2,
        _buildDataSection(context, repo),
        gapH8,
        _buildDonateSection(context, s.currency, isTablet),
      ],
    );
  }

  List<Widget> _buildPrefs(BuildContext context, SettingsNotifier notifier, AppSettings s) {
    final langLabel = s.language == 'ru' ? context.l10n.russian : context.l10n.english;
    final themeLabel = switch (s.theme) {
      'dark' => context.l10n.dark,
      'light' => context.l10n.light,
      'system' => context.l10n.system,
      _ => s.theme,
    };
    final currencyLabel = switch (s.currency) {
      'usd' => context.l10n.usd,
      'rub' => context.l10n.rub,
      'eur' => context.l10n.eur,
      _ => s.currency,
    };

    return [
      _settingsItem(
        context,
        '\u{1F310}',
        context.l10n.language,
        langLabel,
        const [SettingsOption('en', 'English'), SettingsOption('ru', 'Русский')],
        s.language,
        (v) => notifier.update((ss) => ss.copyWith(language: v)),
      ),
      _settingsItem(
        context,
        '\u{1F4CF}',
        context.l10n.distanceUnit,
        s.distanceUnit,
        [SettingsOption('km', context.l10n.km), SettingsOption('mi', context.l10n.mi)],
        s.distanceUnit,
        (v) => notifier.update((ss) => ss.copyWith(distanceUnit: v)),
      ),
      _settingsItem(
        context,
        '\u{1F4B5}',
        context.l10n.currency,
        currencyLabel,
        [
          SettingsOption('usd', context.l10n.usd),
          SettingsOption('rub', context.l10n.rub),
          SettingsOption('eur', context.l10n.eur),
        ],
        s.currency,
        (v) => notifier.update((ss) => ss.copyWith(currency: v)),
      ),
      _settingsItem(
        context,
        '\u{1F3A8}',
        context.l10n.theme,
        themeLabel,
        [
          SettingsOption('dark', context.l10n.dark),
          SettingsOption('light', context.l10n.light),
          SettingsOption('system', context.l10n.system),
        ],
        s.theme,
        (v) => notifier.update((ss) => ss.copyWith(theme: v)),
      ),
    ];
  }

  Widget _settingsItem(
    BuildContext context,
    String icon,
    String title,
    String value,
    List<SettingsOption> options,
    String current,
    void Function(String) onSelected,
  ) {
    return SettingsItem(
      icon: icon,
      title: title,
      value: value,
      onTap: () => showSettingsModal(
        context,
        title: '$icon $title',
        options: options,
        current: current,
        onSelected: onSelected,
      ),
    );
  }
}

Widget _buildDataSection(BuildContext context, CarRepository repo) {
  Future<void> onExport() async {
    final bytes = await exportCsvBytes(repo);
    final path = await FilePicker.saveFile(
      fileName: kBackupFileName,
      type: FileType.custom,
      allowedExtensions: ['csv'],
      bytes: bytes,
    );
    if (path != null && context.mounted) {
      showStyledSnackbar(context, 'Saved to $path');
    }
  }

  Future<void> onImport() async {
    final result = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);
    if (result == null || result.files.isEmpty) return;
    final bytes = await File(result.files.single.path!).readAsBytes();
    if (!context.mounted) return;
    final confirmed = await showConfirmDelete(
      context,
      title: context.l10n.importCsv,
      message: context.l10n.importConfirm,
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await importCsvBytes(repo, bytes);
      if (!context.mounted) return;
      if (context.mounted) context.read<CarListNotifier>().load();
      showStyledSnackbar(context, context.l10n.importSuccess);
    } catch (_) {
      if (context.mounted) showStyledSnackbar(context, context.l10n.importError);
    }
  }

  final column = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FormLabel(context.l10n.data),
      gapH4,
      Row(
        children: [
          Expanded(
            child: SettingsItem(
              key: const Key('export_csv'),
              icon: '\u{1F4E4}',
              title: context.l10n.exportCsv,
              value: '',
              onTap: onExport,
            ),
          ),
          gapW10,
          Expanded(
            child: SettingsItem(
              key: const Key('import_csv'),
              icon: '\u{1F4E5}',
              title: context.l10n.importCsv,
              value: '',
              onTap: onImport,
            ),
          ),
        ],
      ),
    ],
  );

  return column;
}

Widget _buildTabletSettings(BuildContext context, List<Widget> prefs) {
  final rows = List.generate((prefs.length + 1) ~/ 2, (i) {
    final j = i * 2;
    final first = Expanded(child: prefs[j]);
    final second = j + 1 < prefs.length ? [gapW10, Expanded(child: prefs[j + 1])] : null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(children: [first, ...?second]),
    );
  });

  final content = SizedBox(
    width: 600,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [FormLabel(context.l10n.preferences), gapH4, ...rows],
    ),
  );

  return Center(child: content);
}

Widget _buildDonateSection(BuildContext context, String currency, [bool isTablet = false]) {
  final cs = Theme.of(context).colorScheme;
  final divider = Container(
    decoration: BoxDecoration(
      border: Border(top: BorderSide(color: cs.outlineVariant)),
    ),
  );
  final header = Text(
    context.l10n.supportDev,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  );
  return Column(
    children: [
      gapH4,
      divider,
      gapH4,
      Column(
        children: [
          const Text('\u{2764}\u{FE0F}', style: TextStyle(fontSize: 24)),
          header,
          Text(
            context.l10n.helpKeepFree,
            style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
          ),
        ],
      ),
      _buildDonateCardRow(context, currency),
      _buildCustomAmountRow(context, cs),
      _buildDonateFooter(context, cs),
    ],
  );
}

Widget _buildDonateCardRow(BuildContext context, String currency) {
  final coffee = Expanded(
    child: DonateCard(
      icon: '\u{2615}',
      amount: formatCurrency(3, currency),
      desc: context.l10n.coffee,
      onTap: () => _openUrl(context, boostyUrl),
    ),
  );
  final pizza = Expanded(
    child: DonateCard(
      icon: '\u{1F355}',
      amount: formatCurrency(5, currency),
      desc: context.l10n.pizza,
      featured: true,
      onTap: () => _openUrl(context, boostyUrl),
    ),
  );
  final beer = Expanded(
    child: DonateCard(
      icon: '\u{1F37A}',
      amount: formatCurrency(10, currency),
      desc: context.l10n.beer,
      onTap: () => _openUrl(context, boostyUrl),
    ),
  );

  final row = SizedBox(width: 420, child: Row(children: [coffee, gapW8, pizza, gapW8, beer]));

  return Column(
    children: [
      gapH12,
      Center(child: row),
    ],
  );
}

Widget _buildCustomAmountRow(BuildContext context, ColorScheme cs) {
  final inputDeco = InputDecoration(
    hintText: context.l10n.customAmount,
    hintStyle: TextStyle(color: cs.onSurfaceVariant),
    border: InputBorder.none,
  );
  final field = Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        border: Border.all(color: cs.outlineVariant),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        style: TextStyle(color: cs.onSurface, fontSize: 14),
        decoration: inputDeco,
        keyboardType: TextInputType.number,
      ),
    ),
  );
  final btn = CardWrapper(
    onTap: () => _openUrl(context, boostyUrl),
    borderRadius: 10,
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    backgroundColor: AppColors.accent,
    border: const Border(),
    child: Text(
      context.l10n.donate,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
    ),
  );

  final row = SizedBox(width: 420, child: Row(children: [field, gapW8, btn]));

  return Column(
    children: [
      gapH8,
      Center(child: row),
    ],
  );
}

Widget _buildDonateFooter(BuildContext context, ColorScheme cs) {
  final method = DonateMethod(
    icon: const GitHubIcon(),
    label: 'GitHub',
    onTap: () => _openUrl(context, githubUrl),
  );

  final deco = BoxDecoration(
    border: Border(top: BorderSide(color: cs.outlineVariant)),
  );
  final inner = Container(
    padding: const EdgeInsets.only(top: 8),
    decoration: deco,
    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [method]),
  );

  return Padding(
    padding: const EdgeInsets.only(top: 8),
    child: SizedBox(width: 420, child: inner),
  );
}

Future<void> _openUrl(BuildContext context, String url) async {
  final uri = Uri.parse(url);
  final msg = context.l10n.settings;
  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  } catch (_) {
    if (!context.mounted) return;
    showStyledSnackbar(context, msg);
  }
}
