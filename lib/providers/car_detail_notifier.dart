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
}
