// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:test/test.dart';
import 'package:backend/backend.dart';

final _testCar = const Car(
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
  works: const [
    WorkRecord(
      id: 1,
      description: 'Oil change & filter',
      date: '2026-04-12',
      cost: 189,
      category: 'maintenance',
    ),
    WorkRecord(
      id: 2,
      description: 'Brake pads front',
      date: '2026-02-15',
      cost: 470,
      category: 'repair',
    ),
    WorkRecord(
      id: 3,
      description: 'Cabin air filter',
      date: '2026-01-05',
      cost: 95,
      category: 'replacement',
    ),
    WorkRecord(
      id: 4,
      description: 'Annual inspection',
      date: '2026-03-10',
      cost: 150,
      category: 'diagnostic',
    ),
    WorkRecord(
      id: 5,
      description: 'Summer tires swap',
      date: '2026-04-02',
      cost: 320,
      category: 'tires',
    ),
    WorkRecord(
      id: 6,
      description: 'Full tank premium',
      date: '2026-04-10',
      cost: 85,
      category: 'fuel',
    ),
    WorkRecord(
      id: 7,
      description: 'Annual insurance',
      date: '2026-03-15',
      cost: 1200,
      category: 'insurance',
    ),
    WorkRecord(
      id: 8,
      description: 'Premium car wash',
      date: '2026-03-20',
      cost: 45,
      category: 'cleaning',
    ),
  ],
);

void main() {
  group('Car model', () {
    final car = _testCar;

    test('totalSpent sums all work costs', () {
      expect(car.totalSpent, greaterThan(0));
      expect(car.totalSpent, 2554);
    });

    test('lastService returns first work date', () {
      expect(car.lastService, '2026-04-12');
    });

    test('lastService returns N/A for no works', () {
      final empty = const Car(
        id: 99,
        make: 'Test',
        model: 'Car',
        year: 2024,
        plate: 'TST',
        colorHex: '#000000',
        price: 0,
        mileage: 0,
        oilLife: 100,
        oilKm: 0,
        oilMax: 10000,
      );
      expect(empty.lastService, 'N/A');
    });

    test('avgSpent calculates average correctly', () {
      expect(car.avgSpent, greaterThan(0));
    });

    test('categoryTotals groups by category', () {
      final totals = car.categoryTotals;
      expect(totals.containsKey('maintenance'), true);
      expect(totals.containsKey('tires'), true);
      expect(totals['maintenance'], 189);
    });

    test('topCategory returns highest spending category', () {
      final top = car.topCategory;
      expect(top, isNotNull);
      expect(top!.value, greaterThan(0));
    });

    test('topCategory returns null for no works', () {
      final empty = const Car(
        id: 99,
        make: 'Test',
        model: 'Car',
        year: 2024,
        plate: 'TST',
        colorHex: '#000000',
        price: 0,
        mileage: 0,
        oilLife: 100,
        oilKm: 0,
        oilMax: 10000,
      );
      expect(empty.topCategory, isNull);
    });
  });

  group('WorkRecord model', () {
    test('creates work record with correct fields', () {
      final work = const WorkRecord(
        id: 1,
        description: 'Test work',
        date: '2026-01-15',
        cost: 500,
        category: 'maintenance',
      );
      expect(work.id, 1);
      expect(work.description, 'Test work');
      expect(work.date, '2026-01-15');
      expect(work.cost, 500);
      expect(work.category, 'maintenance');
    });
  });

  group('Car.copyWith', () {
    test('copyWith returns a new Car with updated fields', () {
      final car = _testCar;
      final updated = car.copyWith(make: 'Updated');
      expect(updated.make, 'Updated');
      expect(updated.id, car.id);
      expect(updated.model, car.model);
    });

    test('copyWith with no changes returns equal values', () {
      final car = _testCar;
      final copied = car.copyWith();
      expect(copied.make, car.make);
      expect(copied.model, car.model);
      expect(copied.year, car.year);
      expect(copied.plate, car.plate);
      expect(copied.colorHex, car.colorHex);
      expect(copied.price, car.price);
      expect(copied.mileage, car.mileage);
      expect(copied.oilLife, car.oilLife);
      expect(copied.oilKm, car.oilKm);
      expect(copied.oilMax, car.oilMax);
      expect(copied.works, car.works);
    });

    test('copyWith is immutable - original unchanged', () {
      final car = _testCar;
      final _ = car.copyWith(make: 'Changed');
      expect(car.make, isNot('Changed'));
    });

    test('copyWith updates works list', () {
      final car = _testCar;
      final newWorks = <WorkRecord>[];
      final updated = car.copyWith(works: newWorks);
      expect(updated.works, newWorks);
      expect(updated.works, isNot(car.works));
    });
  });

  group('WorkRecord.copyWith', () {
    test('copyWith returns a new WorkRecord with updated fields', () {
      final record = _testCar.works[0];
      final updated = record.copyWith(description: 'Updated');
      expect(updated.description, 'Updated');
      expect(updated.id, record.id);
      expect(updated.date, record.date);
    });

    test('copyWith with no changes returns equal values', () {
      final record = _testCar.works[0];
      final copied = record.copyWith();
      expect(copied.id, record.id);
      expect(copied.description, record.description);
      expect(copied.date, record.date);
      expect(copied.cost, record.cost);
      expect(copied.category, record.category);
    });
  });
}
