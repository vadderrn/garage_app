// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:backend/backend.dart';
import 'package:garage_app/main.dart';

class MockCarRepository implements CarRepository {
  final List<Car> _cars = [];
  int _nextCarId = 1;
  int _nextWorkId = 1;

  MockCarRepository() {
    _cars.addAll([
      Car(
        id: _nextCarId++,
        make: 'BMW',
        model: 'X5',
        year: 2020,
        plate: 'A123BC',
        colorHex: '#1e3a8a',
        price: 45000,
        mileage: 45000,
        oilLife: 65,
        oilKm: 4500,
        oilMax: 10000,
        works: [
          WorkRecord(
            id: _nextWorkId++,
            description: 'Oil change & filter',
            date: '2026-04-12',
            cost: 189,
            category: 'maintenance',
          ),
          WorkRecord(
            id: _nextWorkId++,
            description: 'Summer tires swap',
            date: '2026-04-02',
            cost: 320,
            category: 'tires',
          ),
          WorkRecord(
            id: _nextWorkId++,
            description: 'Annual inspection',
            date: '2026-03-10',
            cost: 150,
            category: 'diagnostic',
          ),
          WorkRecord(
            id: _nextWorkId++,
            description: 'Brake pads front',
            date: '2026-02-15',
            cost: 470,
            category: 'repair',
          ),
          WorkRecord(
            id: _nextWorkId++,
            description: 'Cabin air filter',
            date: '2026-01-05',
            cost: 95,
            category: 'replacement',
          ),
          WorkRecord(
            id: _nextWorkId++,
            description: 'Full tank premium',
            date: '2026-04-10',
            cost: 85,
            category: 'fuel',
          ),
          WorkRecord(
            id: _nextWorkId++,
            description: 'Annual insurance',
            date: '2026-03-15',
            cost: 1200,
            category: 'insurance',
          ),
          WorkRecord(
            id: _nextWorkId++,
            description: 'Premium car wash',
            date: '2026-03-20',
            cost: 45,
            category: 'cleaning',
          ),
        ],
      ),
      Car(
        id: _nextCarId++,
        make: 'Toyota',
        model: 'Camry',
        year: 2022,
        plate: 'M456DE',
        colorHex: '#c0c0c0',
        price: 28000,
        mileage: 28000,
        oilLife: 40,
        oilKm: 6000,
        oilMax: 10000,
        works: [
          WorkRecord(
            id: _nextWorkId++,
            description: 'Oil change',
            date: '2026-04-05',
            cost: 95,
            category: 'maintenance',
          ),
          WorkRecord(
            id: _nextWorkId++,
            description: 'Tire rotation',
            date: '2026-03-20',
            cost: 60,
            category: 'tires',
          ),
        ],
      ),
      Car(
        id: _nextCarId++,
        make: 'Mercedes',
        model: 'C-Class',
        year: 2019,
        plate: 'X789FG',
        colorHex: '#1a1a1a',
        price: 35000,
        mileage: 62000,
        oilLife: 18,
        oilKm: 10500,
        oilMax: 12000,
        works: [
          WorkRecord(
            id: _nextWorkId++,
            description: 'Transmission service',
            date: '2026-03-15',
            cost: 580,
            category: 'repair',
          ),
          WorkRecord(
            id: _nextWorkId++,
            description: 'Oil change',
            date: '2026-02-20',
            cost: 150,
            category: 'maintenance',
          ),
        ],
      ),
    ]);
  }

  @override
  Future<List<Car>> loadCars() async => List.unmodifiable(_cars);
  @override
  Future<Car> insertCar(Car car) async {
    final saved = car.copyWith(id: _nextCarId++);
    _cars.add(saved);
    return saved;
  }

  @override
  Future<Car> updateCar(Car car) async {
    final idx = _cars.indexWhere((c) => c.id == car.id);
    if (idx >= 0) _cars[idx] = car;
    return car;
  }

  @override
  Future<void> deleteCar(int carId) async {
    _cars.removeWhere((c) => c.id == carId);
  }

  @override
  Future<List<WorkRecord>> loadWorkRecords(int carId) async {
    final car = _cars.firstWhere((c) => c.id == carId);
    return List.unmodifiable(car.works);
  }

  @override
  Future<WorkRecord> insertWorkRecord(int carId, WorkRecord record) async {
    final saved = record.copyWith(id: _nextWorkId++);
    final idx = _cars.indexWhere((c) => c.id == carId);
    if (idx >= 0) {
      _cars[idx] = _cars[idx].copyWith(works: [..._cars[idx].works, saved]);
    }
    return saved;
  }

  @override
  Future<WorkRecord> updateWorkRecord(WorkRecord record) async => record;
  @override
  Future<void> deleteWorkRecord(int carId, int workId) async {
    final idx = _cars.indexWhere((c) => c.id == carId);
    if (idx >= 0) {
      _cars[idx] = _cars[idx].copyWith(
        works: _cars[idx].works.where((w) => w.id != workId).toList(),
      );
    }
  }

  @override
  Future<int> getTotalSpent(int carId) async {
    final car = _cars.firstWhere((c) => c.id == carId);
    return car.works.fold<int>(0, (s, w) => s + w.cost);
  }

  @override
  Future<double> getAvgSpent(int carId) async {
    final car = _cars.firstWhere((c) => c.id == carId);
    if (car.works.isEmpty) return 0.0;
    return car.works.fold<int>(0, (s, w) => s + w.cost) / car.works.length;
  }

  @override
  Future<String?> getLastServiceDate(int carId) async {
    final car = _cars.firstWhere((c) => c.id == carId);
    return car.works.isEmpty ? null : car.works.first.date;
  }

  @override
  Future<Map<String, int>> getCategoryTotals(int carId) async {
    final car = _cars.firstWhere((c) => c.id == carId);
    final map = <String, int>{};
    for (final w in car.works) {
      map[w.category] = (map[w.category] ?? 0) + w.cost;
    }
    return map;
  }

  @override
  Future<MapEntry<String, int>?> getTopCategory(int carId) async {
    final totals = await getCategoryTotals(carId);
    if (totals.isEmpty) return null;
    final entries = totals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return entries.first;
  }

  @override
  Future<int> getMonthYearSpending(int carId, int year, int month) async {
    final car = _cars.firstWhere((c) => c.id == carId);
    final ms = month.toString().padLeft(2, '0');
    return car.works
        .where((w) => w.date.startsWith('$year-$ms'))
        .fold<int>(0, (s, w) => s + w.cost);
  }

  @override
  Future<int> getMonthYearWorkCount(int carId, int year, int month) async {
    final car = _cars.firstWhere((c) => c.id == carId);
    final ms = month.toString().padLeft(2, '0');
    return car.works.where((w) => w.date.startsWith('$year-$ms')).length;
  }

  @override
  Future<void> clearAll() async => _cars.clear();
}

class MockSettingsRepo implements SettingsRepository {
  AppSettings _settings = const AppSettings();
  @override
  Future<AppSettings> load() async => _settings;
  @override
  Future<void> save(AppSettings settings) async => _settings = settings;
}

Widget createApp({
  String lang = 'en',
  String unit = 'km',
  String themeUi = 'dark',
  String currency = 'usd',
  ThemeMode theme = ThemeMode.dark,
  CarRepository? carRepo,
  SettingsRepository? settingsRepo,
}) {
  return GarageApp(
    settings: AppSettings(language: lang, distanceUnit: unit, theme: themeUi, currency: currency),
    settingsRepo: settingsRepo ?? MockSettingsRepo(),
    carRepo: carRepo ?? MockCarRepository(),
  );
}

void main() {
  setUp(() {});

  group('Home Screen', () {
    testWidgets('renders title and 3 car cards', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      expect(find.text('\u{1F697} Garage'), findsOneWidget);
      expect(find.text('BMW X5'), findsWidgets);
      expect(find.text('Toyota Camry'), findsWidgets);
      expect(find.text('Mercedes C-Class'), findsWidgets);
    });

    testWidgets('shows settings gear icon', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      expect(find.text('\u{2699}\u{FE0F}'), findsOneWidget);
    });

    testWidgets('shows add car button', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      expect(find.text('+ Add New Car'), findsOneWidget);
    });

    testWidgets('car cards show plate and mileage', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      expect(find.text('A123BC'), findsOneWidget);
      expect(find.textContaining('45,000'), findsWidgets);
    });
  });

  group('Navigation', () {
    testWidgets('tap car card opens detail screen', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('BMW X5'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Service History'), findsOneWidget);
      expect(find.text('\u{2190}'), findsOneWidget);
    });

    testWidgets('back button returns to home', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('BMW X5'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('\u{2190}'));
      await tester.pumpAndSettle();

      expect(find.text('\u{1F697} Garage'), findsOneWidget);
    });

    testWidgets('settings icon opens settings screen', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('\u{2699}\u{FE0F}'));
      await tester.pumpAndSettle();

      expect(find.text('Preferences'), findsOneWidget);
    });

    testWidgets('back from settings returns to home', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('\u{2699}\u{FE0F}'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('\u{2190}'));
      await tester.pumpAndSettle();

      expect(find.text('\u{1F697} Garage'), findsOneWidget);
    });
  });

  group('Detail Screen', () {
    testWidgets('shows car stats', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('BMW X5'));
      await tester.pumpAndSettle();

      expect(find.textContaining('TOTAL SPENT'), findsOneWidget);
      expect(find.textContaining('AVG/SERVICE'), findsOneWidget);
      expect(find.textContaining('LAST SERVICE'), findsOneWidget);
      expect(find.textContaining('TOP CATEGORY'), findsOneWidget);
    });

    testWidgets('shows info bar with plate and price', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('BMW X5'));
      await tester.pumpAndSettle();

      expect(find.text('A123BC'), findsOneWidget);
      expect(find.text('\$45K'), findsOneWidget);
    });

    testWidgets('shows service history list', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('BMW X5'));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Oil change & filter'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Oil change & filter'), findsOneWidget);
      expect(find.textContaining('Service History'), findsOneWidget);
    });

    testWidgets('shows mileage field in work form', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('BMW X5'));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('+ Add Work Record'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('+ Add Work Record'));
      await tester.pumpAndSettle();

      expect(find.text('Mileage'), findsWidgets);
    });
  });

  group('Add Car Dialog — Validation', () {
    testWidgets('shows error on empty make', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('+ Add New Car'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Make is required'), findsOneWidget);
    });

    testWidgets('shows error on empty model', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('+ Add New Car'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Ford');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Model is required'), findsOneWidget);
    });

    testWidgets('shows error on invalid year', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('+ Add New Car'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'Ford');
      await tester.enterText(fields.at(1), 'Focus');
      await tester.enterText(fields.at(2), 'abc');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid year (1900-2099)'), findsOneWidget);
    });

    testWidgets('shows error on invalid price', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('+ Add New Car'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'Ford');
      await tester.enterText(fields.at(1), 'Focus');
      await tester.enterText(fields.at(2), '2024');
      await tester.enterText(fields.at(3), 'XYZ123');
      await tester.enterText(fields.at(4), 'abc');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid price'), findsOneWidget);
    });

    testWidgets('saves car with valid data', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('+ Add New Car'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'Ford');
      await tester.enterText(fields.at(1), 'Focus');
      await tester.enterText(fields.at(2), '2024');
      await tester.enterText(fields.at(3), 'XYZ123');
      await tester.enterText(fields.at(4), '25000');
      await tester.enterText(fields.at(5), '10000');

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Ford Focus'), findsWidgets);
    });

    testWidgets('cancel closes dialog without adding', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('+ Add New Car'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('\u{1F697} Garage'), findsOneWidget);
    });
  });

  group('Add Work Dialog — Validation', () {
    testWidgets('shows error on empty description', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('BMW X5'));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('+ Add Work Record'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('+ Add Work Record'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Description is required'), findsOneWidget);
    });

    testWidgets('shows error on invalid cost', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('BMW X5'));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('+ Add Work Record'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('+ Add Work Record'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'New work');

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid cost greater than 0'), findsOneWidget);
    });

    testWidgets('cancel closes work dialog', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('BMW X5'));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('+ Add Work Record'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('+ Add Work Record'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Service History'), findsOneWidget);
    });

    testWidgets('shows mileage field in work form', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('BMW X5'));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('+ Add Work Record'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('+ Add Work Record'));
      await tester.pumpAndSettle();

      expect(find.text('Mileage'), findsWidgets);
    });
  });

  group('Settings', () {
    testWidgets('shows all settings items', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('\u{2699}\u{FE0F}'));
      await tester.pumpAndSettle();

      expect(find.text('Preferences'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Distance Unit'), findsOneWidget);
      expect(find.text('Currency'), findsOneWidget);
      expect(find.text('Theme'), findsOneWidget);
    });

    testWidgets('language modal opens and shows options', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('\u{2699}\u{FE0F}'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      expect(find.text('English'), findsWidgets);
      expect(find.text('Русский'), findsOneWidget);
    });

    testWidgets('switching to Russian changes UI', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('\u{2699}\u{FE0F}'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Русский'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('\u{2190}'));
      await tester.pumpAndSettle();

      expect(find.text('\u{1F697} Гараж'), findsOneWidget);
    });

    testWidgets('distance unit modal opens', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('\u{2699}\u{FE0F}'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('km'));
      await tester.pumpAndSettle();

      expect(find.text('km'), findsWidgets);
      expect(find.text('mi'), findsOneWidget);
    });

    testWidgets('currency modal opens', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('\u{2699}\u{FE0F}'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('USD'));
      await tester.pumpAndSettle();

      expect(find.text('USD'), findsWidgets);
      expect(find.text('RUB'), findsOneWidget);
      expect(find.text('EUR'), findsOneWidget);
    });

    testWidgets('theme modal opens', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('\u{2699}\u{FE0F}'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      expect(find.text('Dark'), findsWidgets);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);
    });

    testWidgets('Data section shows Export and Import buttons', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('\u{2699}\u{FE0F}'));
      await tester.pumpAndSettle();

      expect(find.text('Data'), findsOneWidget);
      expect(find.text('Export CSV'), findsWidgets);
      expect(find.text('Import CSV'), findsWidgets);
    });
  });

  group('Theme Modes', () {
    testWidgets('light theme renders', (tester) async {
      await tester.pumpWidget(createApp(theme: ThemeMode.light, themeUi: 'light'));
      await tester.pumpAndSettle();

      expect(find.text('\u{1F697} Garage'), findsOneWidget);
      expect(find.text('BMW X5'), findsWidgets);
    });

    testWidgets('system theme renders', (tester) async {
      await tester.pumpWidget(createApp(theme: ThemeMode.system, themeUi: 'system'));
      await tester.pumpAndSettle();

      expect(find.text('\u{1F697} Garage'), findsOneWidget);
    });
  });

  group('Localization', () {
    testWidgets('Russian locale renders home', (tester) async {
      await tester.pumpWidget(createApp(lang: 'ru'));
      await tester.pumpAndSettle();

      expect(find.text('\u{1F697} Гараж'), findsOneWidget);
    });

    testWidgets('Russian settings screen', (tester) async {
      await tester.pumpWidget(createApp(lang: 'ru'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('\u{2699}\u{FE0F}'));
      await tester.pumpAndSettle();

      expect(find.text('Настройки'), findsOneWidget);
    });

    testWidgets('English validation strings', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('+ Add New Car'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Make is required'), findsOneWidget);
    });

    testWidgets('Russian validation strings', (tester) async {
      await tester.pumpWidget(createApp(lang: 'ru'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('+ Добавить авто'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Сохранить'));
      await tester.pumpAndSettle();

      expect(find.text('Введите марку'), findsOneWidget);
    });
  });

  group('Monthly Spending Dialog', () {
    testWidgets('opens from total spent card', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('BMW X5'));
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('TOTAL SPENT'));
      await tester.pumpAndSettle();

      expect(find.text('\u{1F4C5} Monthly Spending'), findsOneWidget);
    });

    testWidgets('has close button', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('BMW X5'));
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('TOTAL SPENT'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Service History'), findsOneWidget);
    });
  });

  group('Category Breakdown Dialog', () {
    testWidgets('opens from top category card', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('BMW X5'));
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('TOP CATEGORY'));
      await tester.pumpAndSettle();

      expect(find.text('\u{1F4CA} Spending by Category'), findsOneWidget);
    });
  });

  group('Oil Life Card', () {
    testWidgets('opens oil change history dialog', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('BMW X5'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('\u{1F6E2} Oil Life'));
      await tester.pumpAndSettle();

      expect(find.text('\u{1F6E2} Oil Change History'), findsOneWidget);
    });
  });

  group('Donate Section', () {
    testWidgets('shows donate cards', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('\u{2699}\u{FE0F}'));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Coffee'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Coffee'), findsOneWidget);
      expect(find.text('Pizza'), findsOneWidget);
      expect(find.text('Beer'), findsOneWidget);
    });
  });

  group('Edit Car Dialog', () {
    testWidgets('opens with pre-filled data', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('BMW X5'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('\u{270F}\u{FE0F}'));
      await tester.pumpAndSettle();

      expect(find.text('\u{270F}\u{FE0F} Edit Car'), findsOneWidget);
    });

    testWidgets('renaming car updates app bar title', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('BMW X5'));
      await tester.pumpAndSettle();

      expect(find.text('BMW X5 2020'), findsOneWidget);

      await tester.tap(find.text('\u{270F}\u{FE0F}'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Audi');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Audi X5 2020'), findsOneWidget);
    });
  });

  group('Car Deletion', () {
    testWidgets('after deletion from detail returns to home', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('BMW X5'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('\u{270F}\u{FE0F}'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('\u{1F5D1}'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(find.text('\u{1F697} Garage'), findsOneWidget);
      expect(find.text('BMW X5'), findsNothing);
      expect(find.text('Toyota Camry'), findsOneWidget);
      expect(find.text('Mercedes C-Class'), findsOneWidget);
    });
  });
}
