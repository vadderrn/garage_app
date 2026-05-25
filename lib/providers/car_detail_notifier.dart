// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/foundation.dart';
import 'package:backend/backend.dart';

class CarDetailNotifier extends ChangeNotifier {
  final CarRepository _repo;
  List<WorkRecord> _works = [];
  int _totalSpent = 0;
  double _avgSpent = 0.0;
  String? _lastService;
  Map<String, int> _categoryTotals = {};
  MapEntry<String, int>? _topCategory;

  CarDetailNotifier(this._repo);

  List<WorkRecord> get works => _works;
  int get totalSpent => _totalSpent;
  double get avgSpent => _avgSpent;
  String? get lastService => _lastService;
  Map<String, int> get categoryTotals => _categoryTotals;
  MapEntry<String, int>? get topCategory => _topCategory;

  Future<void> load(int carId) async {
    await _reloadAll(carId);
  }

  Future<void> _reloadAll(int carId) async {
    _works = await _repo.loadWorkRecords(carId);
    _totalSpent = await _repo.getTotalSpent(carId);
    _avgSpent = await _repo.getAvgSpent(carId);
    _lastService = await _repo.getLastServiceDate(carId);
    _categoryTotals = await _repo.getCategoryTotals(carId);
    _topCategory = await _repo.getTopCategory(carId);
    notifyListeners();
  }

  Future<WorkRecord> addWork(int carId, WorkRecord record) async {
    final saved = await _repo.insertWorkRecord(carId, record);
    _works = [..._works, saved];
    await _reloadAll(carId);
    return saved;
  }

  Future<void> updateWork(int carId, WorkRecord record) async {
    await _repo.updateWorkRecord(record);
    await _reloadAll(carId);
  }

  Future<void> deleteWork(int carId, int workId) async {
    await _repo.deleteWorkRecord(carId, workId);
    await _reloadAll(carId);
  }

  Future<void> recalculateOilLife(int carId, int currentMileage, int oilMax) async {
    if (oilMax <= 0) return;

    final maxWorkKm = _works
        .where((w) => w.mileage != null)
        .fold<int>(currentMileage, (m, w) => w.mileage! > m ? w.mileage! : m);

    final oilWorks = _works.where((w) => w.mileage != null && isOilChange(w.description)).toList()
      ..sort((a, b) {
        final d = b.date.compareTo(a.date);
        return d != 0 ? d : b.id.compareTo(a.id);
      });

    // Load current car to get baseline for last-oil-change mileage
    final cars = await _repo.loadCars();
    final idx = cars.indexWhere((c) => c.id == carId);
    if (idx < 0) return;
    final car = cars[idx];

    final lastOilKm = oilWorks.isNotEmpty ? oilWorks.first.mileage! : car.mileage - car.oilKm;

    final oilKm = (maxWorkKm - lastOilKm).clamp(0, oilMax);
    final oilLife = ((1 - oilKm / oilMax) * 100).round().clamp(0, 100);

    await _repo.updateCar(car.copyWith(mileage: maxWorkKm, oilKm: oilKm, oilLife: oilLife));
  }
}
