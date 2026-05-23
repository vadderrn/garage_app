// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/foundation.dart';
import 'package:backend/backend.dart';

class CarListNotifier extends ChangeNotifier {
  final CarRepository _repo;
  List<Car> _cars = [];
  int? _selectedCarId;

  CarListNotifier(this._repo);

  List<Car> get cars => _cars;
  int? get selectedCarId => _selectedCarId;

  Car? get selectedCar => _cars.where((c) => c.id == _selectedCarId).firstOrNull;

  Future<void> load() async {
    _cars = await _repo.loadCars();
    notifyListeners();
  }

  void selectCar(int? id) {
    _selectedCarId = id;
    notifyListeners();
  }

  Future<Car> add(Car car) async {
    final saved = await _repo.insertCar(car);
    _cars = [..._cars, saved];
    notifyListeners();
    return saved;
  }

  Future<void> update(Car car) async {
    await _repo.updateCar(car);
    final idx = _cars.indexWhere((c) => c.id == car.id);
    if (idx >= 0) {
      _cars = _cars.toList()..[idx] = car;
      notifyListeners();
    }
  }

  Future<void> delete(int id) async {
    await _repo.deleteCar(id);
    _cars = _cars.where((c) => c.id != id).toList();
    if (_selectedCarId == id) {
      _selectedCarId = null;
    }
    notifyListeners();
  }
}
