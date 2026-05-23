// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:test/test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:backend/backend.dart';

void main() {
  group('SqliteCarRepository', () {
    late Database db;
    late SqliteCarRepository repo;

    setUp(() {
      db = sqlite3.openInMemory();
      repo = SqliteCarRepository.inMemory(db);
      seedIfEmpty(db);
    });

    tearDown(() {
      db.close();
    });

    group('seeding', () {
      test('seeds sample cars on empty database', () async {
        final cars = await repo.loadCars();
        expect(cars.length, greaterThan(0));
        expect(cars[0].make, 'BMW');
        expect(cars[0].works.length, greaterThan(0));
      });

      test('does not re-seed on subsequent loads', () async {
        await repo.loadCars();
        final cars = await repo.loadCars();
        expect(cars.length, 3);
      });
    });

    group('Car CRUD', () {
      setUp(() async {
        await repo.loadCars(); // seed
      });

      test('insertCar returns car with assigned id', () async {
        final car = const Car(
          id: -1,
          make: 'Test',
          model: 'Car',
          year: 2024,
          plate: 'TEST',
          colorHex: '#000000',
          price: 10000,
          mileage: 100,
          oilLife: 80,
          oilKm: 5000,
          oilMax: 15000,
        );
        final saved = await repo.insertCar(car);
        expect(saved.id, greaterThan(0));
        expect(saved.id, isNot(-1));
      });

      test('updateCar persists changes', () async {
        final cars = await repo.loadCars();
        final original = cars[0];
        final updated = await repo.updateCar(original.copyWith(make: 'UpdatedMake'));
        expect(updated.make, 'UpdatedMake');
        final reloaded = await repo.loadCars();
        expect(reloaded[0].make, 'UpdatedMake');
      });

      test('deleteCar removes car and its work records', () async {
        final cars = await repo.loadCars();
        final carId = cars[0].id;
        await repo.deleteCar(carId);
        final remaining = await repo.loadCars();
        expect(remaining.length, cars.length - 1);
        expect(remaining.any((c) => c.id == carId), false);
      });
    });

    group('WorkRecord CRUD', () {
      late int carId;

      setUp(() async {
        final cars = await repo.loadCars();
        carId = cars[0].id;
      });

      test('insertWorkRecord returns record with assigned id', () async {
        final record = const WorkRecord(
          id: -1,
          description: 'Test work',
          date: '2024-01-01',
          cost: 500,
          category: 'maintenance',
        );
        final saved = await repo.insertWorkRecord(carId, record);
        expect(saved.id, greaterThan(0));
      });

      test('loadWorkRecords returns records for a car', () async {
        final records = await repo.loadWorkRecords(carId);
        expect(records.length, greaterThan(0));
      });

      test('updateWorkRecord persists changes', () async {
        final records = await repo.loadWorkRecords(carId);
        final original = records[0];
        await repo.updateWorkRecord(original.copyWith(description: 'Updated work'));
        final reloaded = await repo.loadWorkRecords(carId);
        expect(reloaded.any((r) => r.description == 'Updated work'), true);
      });

      test('deleteWorkRecord removes record', () async {
        final records = await repo.loadWorkRecords(carId);
        final workId = records[0].id;
        await repo.deleteWorkRecord(carId, workId);
        final remaining = await repo.loadWorkRecords(carId);
        expect(remaining.any((r) => r.id == workId), false);
      });
    });

    group('aggregate stats', () {
      late int carId;

      setUp(() async {
        final cars = await repo.loadCars();
        carId = cars[0].id;
      });

      test('getTotalSpent returns sum of work costs', () async {
        final total = await repo.getTotalSpent(carId);
        expect(total, greaterThan(0));
      });

      test('getAvgSpent returns average of work costs', () async {
        final avg = await repo.getAvgSpent(carId);
        expect(avg, greaterThan(0));
      });

      test('getLastServiceDate returns earliest work date', () async {
        final date = await repo.getLastServiceDate(carId);
        expect(date, isNotNull);
      });

      test('getCategoryTotals returns map grouped by category', () async {
        final totals = await repo.getCategoryTotals(carId);
        expect(totals, isNotEmpty);
        expect(totals.values, everyElement(greaterThan(0)));
      });

      test('getTopCategory returns highest spending category', () async {
        final top = await repo.getTopCategory(carId);
        expect(top, isNotNull);
      });

      test('getMonthYearSpending returns spending for a month', () async {
        final records = await repo.loadWorkRecords(carId);
        final dateParts = records[0].date.split('-');
        final year = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final spending = await repo.getMonthYearSpending(carId, year, month);
        expect(spending, greaterThan(0));
      });

      test('getMonthYearWorkCount returns count for a month', () async {
        final records = await repo.loadWorkRecords(carId);
        final dateParts = records[0].date.split('-');
        final year = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final count = await repo.getMonthYearWorkCount(carId, year, month);
        expect(count, greaterThan(0));
      });

      test('stats return zero/default for non-existent car', () async {
        final total = await repo.getTotalSpent(99999);
        expect(total, 0);
        final avg = await repo.getAvgSpent(99999);
        expect(avg, 0.0);
        final date = await repo.getLastServiceDate(99999);
        expect(date, isNull);
        final totals = await repo.getCategoryTotals(99999);
        expect(totals, isEmpty);
        final top = await repo.getTopCategory(99999);
        expect(top, isNull);
      });
    });

    group('fresh repository', () {
      test('loadCars returns seeded cars', () async {
        final freshDb = sqlite3.openInMemory();
        final freshRepo = SqliteCarRepository.inMemory(freshDb);
        seedIfEmpty(freshDb);
        final cars = await freshRepo.loadCars();
        expect(cars.length, 3);
        freshDb.close();
      });
    });
  });
}
