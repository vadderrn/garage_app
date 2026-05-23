// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:sqlite3/sqlite3.dart';
import 'models.dart';
import 'repository.dart';
import 'labels.dart';
import 'sql_queries.dart';

class SqliteCarRepository implements CarRepository {
  final Database _db;

  Database get database => _db;

  SqliteCarRepository(Database db) : _db = db {
    _createTables();
  }

  factory SqliteCarRepository.open(String path) {
    final db = sqlite3.open(path);
    return SqliteCarRepository(db);
  }

  SqliteCarRepository.inMemory(Database db) : this(db);

  void _createTables() {
    _db.execute(createTablesSQL);
    _db.execute(createWorkRecordsTableSQL);
  }

  @override
  Future<List<Car>> loadCars() async {
    final rows = _db.select(loadAllCarsSQL);
    final cars = <Car>[];
    for (final row in rows) {
      final car = Car.fromJson(row);
      final works = _loadWorkRecordsSync(car.id);
      cars.add(car.copyWith(works: works));
    }
    return cars;
  }

  List<WorkRecord> _loadWorkRecordsSync(int carId) {
    final rows = _db.select(loadWorkRecordsSQL, [carId]);
    return rows.map((r) => WorkRecord.fromJson(r)).toList();
  }

  @override
  Future<List<WorkRecord>> loadWorkRecords(int carId) async {
    return _loadWorkRecordsSync(carId);
  }

  @override
  Future<Car> insertCar(Car car) async {
    _db.execute(insertCarSQL, [
      car.make,
      car.model,
      car.year,
      car.plate,
      car.colorHex,
      car.price,
      car.mileage,
      car.oilLife,
      car.oilKm,
      car.oilMax,
    ]);
    final id = _db.lastInsertRowId;
    return car.copyWith(id: id);
  }

  @override
  Future<Car> updateCar(Car car) async {
    _db.execute(updateCarSQL, [
      car.make,
      car.model,
      car.year,
      car.plate,
      car.colorHex,
      car.price,
      car.mileage,
      car.oilLife,
      car.oilKm,
      car.oilMax,
      car.id,
    ]);
    return car;
  }

  @override
  Future<void> deleteCar(int carId) async {
    _db.execute(deleteWorkRecordsByCarSQL, [carId]);
    _db.execute(deleteCarSQL, [carId]);
  }

  @override
  Future<WorkRecord> insertWorkRecord(int carId, WorkRecord record) async {
    _db.execute(insertWorkRecordSQL, [
      carId,
      record.description,
      record.date,
      record.cost,
      record.category,
    ]);
    final id = _db.lastInsertRowId;
    return record.copyWith(id: id);
  }

  @override
  Future<WorkRecord> updateWorkRecord(WorkRecord record) async {
    _db.execute(updateWorkRecordSQL, [
      record.description,
      record.date,
      record.cost,
      record.category,
      record.id,
    ]);
    return record;
  }

  @override
  Future<void> deleteWorkRecord(int carId, int workId) async {
    _db.execute(deleteWorkRecordSQL, [workId, carId]);
  }

  @override
  Future<int> getTotalSpent(int carId) async {
    final result = _db.select(getTotalSpentSQL, [carId]);
    return (result.first['s'] as int?) ?? 0;
  }

  @override
  Future<double> getAvgSpent(int carId) async {
    final result = _db.select(getAvgSpentSQL, [carId]);
    return (result.first['a'] as num?)?.toDouble() ?? 0.0;
  }

  @override
  Future<String?> getLastServiceDate(int carId) async {
    final result = _db.select(getLastServiceDateSQL, [carId]);
    if (result.isEmpty) return null;
    return result.first['date'] as String?;
  }

  @override
  Future<Map<String, int>> getCategoryTotals(int carId) async {
    final result = _db.select(getCategoryTotalsSQL, [carId]);
    final map = <String, int>{};
    for (final row in result) {
      map[row['category'] as String] = row['total'] as int;
    }
    return map;
  }

  @override
  Future<MapEntry<String, int>?> getTopCategory(int carId) async {
    final result = _db.select(getTopCategorySQL, [carId]);
    if (result.isEmpty) return null;
    return MapEntry(result.first['category'] as String, result.first['total'] as int);
  }

  @override
  Future<int> getMonthYearSpending(int carId, int year, int month) async {
    final monthStr = formatMonth(month);
    final result = _db.select(getMonthYearSpendingSQL, [carId, year.toString(), monthStr]);
    return (result.first['s'] as int?) ?? 0;
  }

  @override
  Future<int> getMonthYearWorkCount(int carId, int year, int month) async {
    final monthStr = formatMonth(month);
    final result = _db.select(getMonthYearWorkCountSQL, [carId, year.toString(), monthStr]);
    return result.first['c'] as int;
  }
}
