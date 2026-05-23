// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:backend/backend.dart';
import 'package:ui/ui.dart';
import 'l10n/app_localizations.g.dart';
import 'l10n_adapter.dart';
import 'providers/providers.dart';
import 'screens/screens.dart';
import 'screens/dialogs/dialogs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final carRepo = SqliteCarRepository.open('${dir.path}/garage.db');
  if (!kReleaseMode) seedIfEmpty(carRepo.database);
  final settingsRepo = SqliteSettingsRepository(carRepo.database);
  final settings = await settingsRepo.load();
  runApp(GarageApp(carRepo: carRepo, settingsRepo: settingsRepo, settings: settings));
}

class GarageApp extends StatelessWidget {
  final CarRepository carRepo;
  final SettingsRepository settingsRepo;
  final AppSettings settings;

  const GarageApp({
    super.key,
    required this.carRepo,
    required this.settingsRepo,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final app = Consumer<SettingsNotifier>(
      builder: (context, notifier, _) {
        final theme = switch (notifier.settings.theme) {
          'light' => ThemeMode.light,
          'system' => ThemeMode.system,
          _ => ThemeMode.dark,
        };
        return MaterialApp(
          title: 'Garage',
          debugShowCheckedModeBanner: false,
          locale: Locale(notifier.language),
          themeMode: theme,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => Provider<L10n>.value(
            value: AppL10nAdapter(AppLocalizations.of(context)!),
            child: child!,
          ),
          home: const GarageHome(),
        );
      },
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsNotifier(settingsRepo, settings)),
        Provider<CarRepository>.value(value: carRepo),
        ChangeNotifierProvider(create: (_) => CarListNotifier(carRepo)),
        ChangeNotifierProvider(create: (_) => CarDetailNotifier(carRepo)),
        ChangeNotifierProvider(
          create: (ctx) {
            ctx.read<CarListNotifier>().load();
            return NavigationNotifier();
          },
        ),
      ],
      child: app,
    );
  }
}

class GarageHome extends StatelessWidget {
  const GarageHome({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavigationNotifier>();

    void onAddCar() =>
        showCarFormDialog(context, null, (car) => context.read<CarListNotifier>().add(car));
    Future<void> onOpenDetail(int carId) async {
      context.read<CarListNotifier>().selectCar(carId);
      await context.read<CarDetailNotifier>().load(carId);
      if (context.mounted) nav.push(Screen.detail);
    }

    void onEditCar() => showCarFormDialog(
      context,
      context.read<CarListNotifier>().selectedCar,
      (car) => context.read<CarListNotifier>().update(car),
    );

    const rightGap = EdgeInsets.only(right: 20);
    final showBack = nav.current != Screen.home;
    final backBtn = showBack
        ? Padding(
            padding: const EdgeInsets.only(left: 20),
            child: circularBtn(context, text: '\u{2190}', fontSize: 24, onTap: nav.pop),
          )
        : null;
    final editBtn = Padding(
      padding: rightGap,
      child: circularBtn(context, text: '\u{270F}\u{FE0F}', onTap: onEditCar, fontSize: 16),
    );
    final settingsBtn = Padding(
      padding: rightGap,
      child: circularBtn(
        context,
        text: '\u{2699}\u{FE0F}',
        onTap: () => nav.push(Screen.settings),
        fontSize: 16,
      ),
    );

    return PopScope(
      canPop: nav.canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) nav.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: showBack ? 56 : null,
          titleSpacing: 20,
          leading: backBtn,
          title: _buildTitle(context),
          actions: nav.current == Screen.detail
              ? [editBtn]
              : nav.current == Screen.home
              ? [settingsBtn]
              : [],
        ),
        body: switch (nav.current) {
          Screen.home => HomeScreen(onAddCar: onAddCar, onTapCar: onOpenDetail),
          Screen.detail => const DetailScreen(),
          Screen.settings => const SettingsScreen(),
        },
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final nav = context.read<NavigationNotifier>();
    switch (nav.current) {
      case Screen.home:
        return Text(context.l10n.garage);
      case Screen.detail:
        return Consumer<CarListNotifier>(
          builder: (_, notifier, _) {
            final car = notifier.selectedCar;
            if (car == null) return const Text('Detail');
            final title = Text(
              '${car.make} ${car.model} ${car.year}',
              overflow: TextOverflow.ellipsis,
            );
            return Row(
              children: [
                ColorDot(color: car.color, size: 16),
                gapW8,
                Flexible(child: title),
              ],
            );
          },
        );
      case Screen.settings:
        return Text(context.l10n.settings);
    }
  }
}
