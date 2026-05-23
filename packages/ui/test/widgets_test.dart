// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:backend/backend.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';
import 'src/mock_l10n.dart';

const _testCar = Car(
  id: 1,
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
      id: 1,
      description: 'Oil change & filter',
      date: '2026-04-12',
      cost: 189,
      category: 'maintenance',
    ),
  ],
);

final _mockL10n = MockL10n();
Widget _wrap(Widget child) => MaterialApp(
  home: Provider<L10n>.value(
    value: _mockL10n,
    child: Scaffold(body: child),
  ),
);

void main() {
  group('CarCard', () {
    testWidgets('renders make and model', (tester) async {
      await tester.pumpWidget(
        _wrap(CarCard(car: _testCar, currency: 'usd', distanceUnit: 'km', onTap: () {})),
      );
      expect(find.text('BMW X5'), findsOneWidget);
    });

    testWidgets('renders plate', (tester) async {
      await tester.pumpWidget(
        _wrap(CarCard(car: _testCar, currency: 'usd', distanceUnit: 'km', onTap: () {})),
      );
      expect(find.text('A123BC'), findsOneWidget);
    });

    testWidgets('renders price formatted', (tester) async {
      await tester.pumpWidget(
        _wrap(CarCard(car: _testCar, currency: 'usd', distanceUnit: 'km', onTap: () {})),
      );
      expect(find.textContaining('\$45K'), findsOneWidget);
    });

    testWidgets('fires onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          CarCard(car: _testCar, currency: 'usd', distanceUnit: 'km', onTap: () => tapped = true),
        ),
      );
      await tester.tap(find.text('BMW X5'));
      expect(tapped, isTrue);
    });

    testWidgets('shows mileage label', (tester) async {
      await tester.pumpWidget(
        _wrap(CarCard(car: _testCar, currency: 'usd', distanceUnit: 'km', onTap: () {})),
      );
      expect(find.text('Mileage'), findsOneWidget);
    });

    testWidgets('shows mileage value', (tester) async {
      await tester.pumpWidget(
        _wrap(CarCard(car: _testCar, currency: 'usd', distanceUnit: 'km', onTap: () {})),
      );
      expect(find.text('45,000 km'), findsOneWidget);
    });

    testWidgets('shows total spent label', (tester) async {
      await tester.pumpWidget(
        _wrap(CarCard(car: _testCar, currency: 'usd', distanceUnit: 'km', onTap: () {})),
      );
      expect(find.text('Total Spent'), findsOneWidget);
    });

    testWidgets('shows total spent value', (tester) async {
      await tester.pumpWidget(
        _wrap(CarCard(car: _testCar, currency: 'usd', distanceUnit: 'km', onTap: () {})),
      );
      expect(find.text('\$189'), findsOneWidget);
    });

    testWidgets('shows year label', (tester) async {
      await tester.pumpWidget(
        _wrap(CarCard(car: _testCar, currency: 'usd', distanceUnit: 'km', onTap: () {})),
      );
      expect(find.text('Year'), findsOneWidget);
    });
  });

  group('OilLifeCard', () {
    testWidgets('shows oil life percentage', (tester) async {
      await tester.pumpWidget(
        _wrap(const OilLifeCard(oilLife: 65, oilKm: 4500, oilMax: 10000, distanceUnit: 'km')),
      );
      expect(find.textContaining('65%'), findsOneWidget);
    });

    testWidgets('shows good status for high oil life', (tester) async {
      await tester.pumpWidget(
        _wrap(const OilLifeCard(oilLife: 80, oilKm: 2000, oilMax: 10000, distanceUnit: 'km')),
      );
      expect(find.textContaining('Good'), findsOneWidget);
    });

    testWidgets('shows due soon for medium oil life', (tester) async {
      await tester.pumpWidget(
        _wrap(const OilLifeCard(oilLife: 35, oilKm: 6500, oilMax: 10000, distanceUnit: 'km')),
      );
      expect(find.textContaining('Due Soon'), findsOneWidget);
    });

    testWidgets('shows overdue for low oil life', (tester) async {
      await tester.pumpWidget(
        _wrap(const OilLifeCard(oilLife: 15, oilKm: 9500, oilMax: 10000, distanceUnit: 'km')),
      );
      expect(find.textContaining('Overdue'), findsOneWidget);
    });

    testWidgets('shows oil life label', (tester) async {
      await tester.pumpWidget(
        _wrap(const OilLifeCard(oilLife: 65, oilKm: 4500, oilMax: 10000, distanceUnit: 'km')),
      );
      expect(find.text('Oil Life'), findsOneWidget);
    });

    testWidgets('shows since change text', (tester) async {
      await tester.pumpWidget(
        _wrap(const OilLifeCard(oilLife: 65, oilKm: 4500, oilMax: 10000, distanceUnit: 'km')),
      );
      expect(find.textContaining('since change'), findsOneWidget);
    });

    testWidgets('shows max text', (tester) async {
      await tester.pumpWidget(
        _wrap(const OilLifeCard(oilLife: 65, oilKm: 4500, oilMax: 10000, distanceUnit: 'km')),
      );
      expect(find.textContaining('Max'), findsOneWidget);
    });
  });

  group('WorkItem', () {
    testWidgets('renders description and date', (tester) async {
      await tester.pumpWidget(_wrap(WorkItem(work: _testCar.works[0], currency: 'usd')));
      expect(find.text('Oil change & filter'), findsOneWidget);
      expect(find.textContaining('2026-04-12'), findsOneWidget);
    });

    testWidgets('renders cost formatted', (tester) async {
      await tester.pumpWidget(_wrap(WorkItem(work: _testCar.works[0], currency: 'usd')));
      expect(find.textContaining('-\$189'), findsOneWidget);
    });

    testWidgets('fires onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(WorkItem(work: _testCar.works[0], currency: 'usd', onTap: () => tapped = true)),
      );
      await tester.tap(find.text('Oil change & filter'));
      expect(tapped, isTrue);
    });

    testWidgets('shows category label', (tester) async {
      await tester.pumpWidget(_wrap(WorkItem(work: _testCar.works[0], currency: 'usd')));
      expect(find.textContaining('Maintenance'), findsOneWidget);
    });
  });

  group('CategorySelector', () {
    testWidgets('renders category labels', (tester) async {
      await tester.pumpWidget(
        _wrap(CategorySelector(categories: categories, selected: 'maintenance', onSelect: (_) {})),
      );
      expect(find.text('Maintenance'), findsOneWidget);
      expect(find.text('Repair'), findsOneWidget);
    });
  });

  group('StatCard', () {
    testWidgets('renders label and value', (tester) async {
      await tester.pumpWidget(_wrap(const StatCard(label: 'Total Spent', value: Text('\$2,554'))));
      expect(find.textContaining('TOTAL SPENT'), findsOneWidget);
      expect(find.text('\$2,554'), findsOneWidget);
    });

    testWidgets('shows arrow when onTap provided', (tester) async {
      await tester.pumpWidget(
        _wrap(StatCard(label: 'Total', value: const Text('\$100'), onTap: () {})),
      );
      expect(find.text('\u{203A}'), findsOneWidget);
    });

    testWidgets('renders subtitle', (tester) async {
      await tester.pumpWidget(
        _wrap(const StatCard(label: 'Test', value: Text('Val'), subtitle: Text('Sub'))),
      );
      expect(find.text('Sub'), findsOneWidget);
    });

    testWidgets('fires onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(StatCard(label: 'Test', value: const Text('Val'), onTap: () => tapped = true)),
      );
      await tester.tap(find.textContaining('TEST'));
      expect(tapped, isTrue);
    });
  });

  group('AddButton', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(_wrap(AddButton(label: '+ Add New Car', onTap: () {})));
      expect(find.text('+ Add New Car'), findsOneWidget);
    });

    testWidgets('fires onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(AddButton(label: 'Tap Me', onTap: () => tapped = true)));
      await tester.tap(find.text('Tap Me'));
      expect(tapped, isTrue);
    });
  });

  group('SettingsItem', () {
    testWidgets('renders icon, title and value', (tester) async {
      await tester.pumpWidget(
        _wrap(SettingsItem(icon: '\u{1F310}', title: 'Language', value: 'English', onTap: () {})),
      );
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
    });

    testWidgets('fires onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          SettingsItem(icon: '\u{2699}', title: 'Theme', value: 'Dark', onTap: () => tapped = true),
        ),
      );
      await tester.tap(find.text('Theme'));
      expect(tapped, isTrue);
    });
  });

  group('DonateCard', () {
    testWidgets('renders icon, amount and desc', (tester) async {
      await tester.pumpWidget(
        _wrap(DonateCard(icon: '\u{2615}', amount: '\$3', desc: 'Coffee', onTap: () {})),
      );
      expect(find.text('\u{2615}'), findsOneWidget);
      expect(find.text('\$3'), findsOneWidget);
      expect(find.text('Coffee'), findsOneWidget);
    });

    testWidgets('fires onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          DonateCard(icon: '\u{2615}', amount: '\$3', desc: 'Coffee', onTap: () => tapped = true),
        ),
      );
      await tester.tap(find.text('Coffee'));
      expect(tapped, isTrue);
    });

    testWidgets('featured card shows Popular badge', (tester) async {
      await tester.pumpWidget(
        _wrap(
          DonateCard(icon: '\u{1F355}', amount: '\$5', desc: 'Pizza', featured: true, onTap: () {}),
        ),
      );
      expect(find.text('Popular'), findsOneWidget);
    });
  });

  group('ColorDot', () {
    testWidgets('renders colored circle', (tester) async {
      await tester.pumpWidget(_wrap(const ColorDot(color: Colors.blue)));
      expect(find.byType(ColorDot), findsOneWidget);
    });
  });

  group('MiniProgressBar', () {
    testWidgets('renders with fraction', (tester) async {
      await tester.pumpWidget(_wrap(const MiniProgressBar(fraction: 0.5, color: Colors.green)));
      expect(find.byType(MiniProgressBar), findsOneWidget);
    });
  });

  group('SummaryCard', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(_wrap(const SummaryCard(child: Text('Summary content'))));
      expect(find.text('Summary content'), findsOneWidget);
    });
  });

  group('CardWrapper', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(_wrap(const CardWrapper(child: Text('Wrapper content'))));
      expect(find.text('Wrapper content'), findsOneWidget);
    });

    testWidgets('fires onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(CardWrapper(child: const Text('Tap wrapper'), onTap: () => tapped = true)),
      );
      await tester.tap(find.text('Tap wrapper'));
      expect(tapped, isTrue);
    });
  });

  group('DonateMethod', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(
        _wrap(DonateMethod(icon: const Icon(Icons.star), label: 'GitHub', onTap: () {})),
      );
      expect(find.text('GitHub'), findsOneWidget);
    });
  });

  group('showConfirmDelete', () {
    testWidgets('shows dialog with cancel and delete', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showConfirmDelete(
                context,
                title: 'Delete Car',
                message: 'This will remove the car.',
              ),
              child: const Text('Trigger'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle();
      expect(find.text('Delete Car'), findsOneWidget);
      expect(find.text('This will remove the car.'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });
  });
}
