// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'models.dart';

abstract class CarRepository {
  Future<List<Car>> loadCars();
  Future<Car> insertCar(Car car);
  Future<Car> updateCar(Car car);
  Future<void> deleteCar(int carId);
  Future<List<WorkRecord>> loadWorkRecords(int carId);
  Future<WorkRecord> insertWorkRecord(int carId, WorkRecord record);
  Future<WorkRecord> updateWorkRecord(WorkRecord record);
  Future<void> deleteWorkRecord(int carId, int workId);
  Future<int> getTotalSpent(int carId);
  Future<double> getAvgSpent(int carId);
  Future<String?> getLastServiceDate(int carId);
  Future<Map<String, int>> getCategoryTotals(int carId);
  Future<MapEntry<String, int>?> getTopCategory(int carId);
  Future<int> getMonthYearSpending(int carId, int year, int month);
  Future<int> getMonthYearWorkCount(int carId, int year, int month);
  Future<void> clearAll();
}
