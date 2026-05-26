import 'package:flutter_test/flutter_test.dart';
import 'package:backend/backend.dart';
import 'package:garage_app/providers/providers.dart';

class MockRepo implements CarRepository {
  List<Car> _cars = [];
  int _nextWorkId = 1;

  @override
  Future<List<Car>> loadCars() async => List.unmodifiable(_cars);

  @override
  Future<Car> insertCar(Car car) async {
    _cars = [..._cars, car];
    return car;
  }

  @override
  Future<Car> updateCar(Car car) async {
    final idx = _cars.indexWhere((c) => c.id == car.id);
    if (idx >= 0) _cars = _cars.toList()..[idx] = car;
    return car;
  }

  @override
  Future<void> deleteCar(int id) async {
    _cars = _cars.where((c) => c.id != id).toList();
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
  Future<int> getTotalSpent(int carId) async => 0;
  @override
  Future<double> getAvgSpent(int carId) async => 0.0;
  @override
  Future<String?> getLastServiceDate(int carId) async => null;
  @override
  Future<Map<String, int>> getCategoryTotals(int carId) async => {};
  @override
  Future<MapEntry<String, int>?> getTopCategory(int carId) async => null;
  @override
  Future<int> getMonthYearSpending(int carId, int year, int month) async => 0;
  @override
  Future<int> getMonthYearWorkCount(int carId, int year, int month) async => 0;
  @override
  Future<void> clearAll() async => _cars.clear();
}

void main() {
  group('CarDetailNotifier.recalculateOilLife', () {
    late MockRepo repo;
    late CarDetailNotifier notifier;
    late Car car;

    setUp(() async {
      repo = MockRepo();
      notifier = CarDetailNotifier(repo);

      car = const Car(
        id: 1,
        make: 'Test',
        model: 'Car',
        year: 2024,
        plate: 'TST',
        colorHex: '#000',
        price: 10000,
        mileage: 50000,
        oilLife: 100,
        oilKm: 0,
        oilMax: 10000,
      );
      await repo.insertCar(car);
      await notifier.load(1);
    });

    test('keeps oil at 100 when no distance driven since baseline', () async {
      await repo.insertWorkRecord(
        1,
        const WorkRecord(
          id: -1,
          description: 'Tire change',
          date: '2026-01-01',
          cost: 100,
          category: 'maintenance',
        ),
      );
      await notifier.load(1);
      await notifier.recalculateOilLife(1, 50000, 10000);

      final cars = await repo.loadCars();
      expect(cars[0].oilLife, 100, reason: 'no mileage recorded → baseline = stored km');
      expect(cars[0].oilKm, 0, reason: 'no distance driven since baseline');
    });

    test('degrades oil life from car initial mileage when no oil changes exist', () async {
      // Car created at 300 km, work logged at 4350 km, no oil changes yet
      await repo.updateCar(car.copyWith(mileage: 300, oilKm: 0));
      await repo.insertWorkRecord(
        1,
        const WorkRecord(
          id: -1,
          description: 'Brake pads',
          date: '2026-03-01',
          cost: 200,
          category: 'maintenance',
          mileage: 4350,
        ),
      );
      await notifier.load(1);
      await notifier.recalculateOilLife(1, 300, 10000);

      final cars = await repo.loadCars();
      expect(cars[0].oilKm, 4050, reason: '4350 - 300 = 4050 km driven since new');
      expect(cars[0].oilLife, 60, reason: '((1 - 4050/10000) * 100).round() = 60');
      expect(cars[0].mileage, 4350, reason: 'car mileage updated to highest work km');
    });

    test('further degrades oil life on subsequent non-oil work', () async {
      // Car already calculated at 300 baseline → oilKm 4050, mileage 4350
      await repo.updateCar(car.copyWith(mileage: 4350, oilKm: 4050, oilLife: 60));
      await repo.insertWorkRecord(
        1,
        const WorkRecord(
          id: -1,
          description: 'Brake pads',
          date: '2026-03-01',
          cost: 200,
          category: 'maintenance',
          mileage: 4350,
        ),
      );
      await repo.insertWorkRecord(
        1,
        const WorkRecord(
          id: -1,
          description: 'Tires',
          date: '2026-07-01',
          cost: 500,
          category: 'tires',
          mileage: 8000,
        ),
      );
      await notifier.load(1);
      await notifier.recalculateOilLife(1, 4350, 10000);

      final cars = await repo.loadCars();
      expect(cars[0].oilKm, 7700, reason: '8000 - 300 = 7700 km driven since new');
      expect(cars[0].oilLife, 23, reason: '((1 - 7700/10000) * 100).round() = 23');
    });

    test('resets oil life to 100 when oil change matches current mileage', () async {
      await repo.insertWorkRecord(
        1,
        const WorkRecord(
          id: -1,
          description: 'Oil change',
          date: '2026-01-01',
          cost: 100,
          category: 'maintenance',
          mileage: 50000,
        ),
      );
      await notifier.load(1);
      await notifier.recalculateOilLife(1, 50000, 10000);

      final cars = await repo.loadCars();
      expect(cars[0].oilLife, 100);
      expect(cars[0].oilKm, 0);
    });

    test('reduces oil life based on distance driven since oil change', () async {
      await repo.insertWorkRecord(
        1,
        const WorkRecord(
          id: -1,
          description: 'Oil change',
          date: '2026-01-01',
          cost: 100,
          category: 'maintenance',
          mileage: 40000,
        ),
      );
      await notifier.load(1);
      await notifier.recalculateOilLife(1, 50000, 10000);

      final cars = await repo.loadCars();
      expect(cars[0].oilKm, 10000);
      expect(cars[0].oilLife, 0);
    });

    test('handles partial oil life correctly', () async {
      await repo.insertWorkRecord(
        1,
        const WorkRecord(
          id: -1,
          description: 'Oil change',
          date: '2026-01-01',
          cost: 100,
          category: 'maintenance',
          mileage: 40000,
        ),
      );
      await notifier.load(1);
      await notifier.recalculateOilLife(1, 42500, 10000);

      final cars = await repo.loadCars();
      expect(cars[0].oilKm, 2500);
      expect(cars[0].oilLife, 75);
    });

    test('uses highest work record mileage, not just car stored mileage', () async {
      // Car stored at 45000, oil change at 46000 (higher than stored)
      await repo.insertWorkRecord(
        1,
        const WorkRecord(
          id: -1,
          description: 'Oil change',
          date: '2026-03-01',
          cost: 100,
          category: 'maintenance',
          mileage: 46000,
        ),
      );
      await notifier.load(1);
      await notifier.recalculateOilLife(1, 45000, 10000);

      var cars = await repo.loadCars();
      expect(cars[0].mileage, 46000, reason: 'car mileage updated to work record value');
      expect(cars[0].oilLife, 100, reason: 'oil changed at current mileage');

      // Add non-oil work at 47000 → oil should degrade
      await repo.insertWorkRecord(
        1,
        const WorkRecord(
          id: -1,
          description: 'Serv',
          date: '2026-04-01',
          cost: 50,
          category: 'maintenance',
          mileage: 47000,
        ),
      );
      await notifier.load(1);
      await notifier.recalculateOilLife(1, 46000, 10000);

      cars = await repo.loadCars();
      expect(cars[0].mileage, 47000, reason: 'car mileage updated to latest work value');
      expect(cars[0].oilKm, 1000, reason: '1000 km driven since oil change');
      expect(cars[0].oilLife, 90, reason: '90% remaining');
    });

    test('same-date oil changes: uses highest id as most recent', () async {
      // Two oil changes on same date — second has higher id, higher mileage
      await repo.insertWorkRecord(
        1,
        const WorkRecord(
          id: -1,
          description: 'Oil change',
          date: '2026-05-25',
          cost: 100,
          category: 'maintenance',
          mileage: 46000,
        ),
      );
      await repo.insertWorkRecord(
        1,
        const WorkRecord(
          id: -1,
          description: 'Замена масла',
          date: '2026-05-25',
          cost: 150,
          category: 'maintenance',
          mileage: 48000,
        ),
      );
      await notifier.load(1);
      // currentMileage lower than work mileage to test tiebreaker
      await notifier.recalculateOilLife(1, 45000, 10000);

      final cars = await repo.loadCars();
      expect(cars[0].oilLife, 100, reason: 'most recent (higher id) oil change used');
      expect(cars[0].oilKm, 0, reason: 'oil change at 48000 matches max work km 48000');
    });

    test('handles oilMax of zero without crash', () async {
      await repo.insertWorkRecord(
        1,
        const WorkRecord(
          id: -1,
          description: 'Oil change',
          date: '2026-01-01',
          cost: 100,
          category: 'maintenance',
          mileage: 50000,
        ),
      );
      await notifier.load(1);
      // oilMax=0 should not cause division by zero
      await notifier.recalculateOilLife(1, 50000, 0);

      final cars = await repo.loadCars();
      expect(cars[0].oilLife, 100, reason: 'no change if oilMax is 0');
      expect(cars[0].oilKm, 0, reason: 'no change if oilMax is 0');
    });

    test('mileage lower than last oil change clamps to 0', () async {
      await repo.insertWorkRecord(
        1,
        const WorkRecord(
          id: -1,
          description: 'Oil change',
          date: '2026-01-01',
          cost: 100,
          category: 'maintenance',
          mileage: 50000,
        ),
      );
      await notifier.load(1);
      // User types mileage 30000 (lower than oil change at 50000) — typo scenario
      await notifier.recalculateOilLife(1, 30000, 10000);

      final cars = await repo.loadCars();
      expect(cars[0].oilKm, 0, reason: 'clamped to 0');
      expect(cars[0].oilLife, 100, reason: 'safe default');
    });

    test('null mileage records do not affect calculation', () async {
      await repo.insertWorkRecord(
        1,
        const WorkRecord(
          id: -1,
          description: 'Wash',
          date: '2026-01-01',
          cost: 20,
          category: 'cleaning',
          // mileage: null (default)
        ),
      );
      await repo.insertWorkRecord(
        1,
        const WorkRecord(
          id: -1,
          description: 'Oil change',
          date: '2026-01-02',
          cost: 100,
          category: 'maintenance',
          mileage: 50000,
        ),
      );
      await repo.insertWorkRecord(
        1,
        const WorkRecord(
          id: -1,
          description: 'Tires',
          date: '2026-01-03',
          cost: 200,
          category: 'tires',
          // mileage: null (default)
        ),
      );
      await notifier.load(1);
      await notifier.recalculateOilLife(1, 50000, 10000);

      final cars = await repo.loadCars();
      expect(cars[0].oilLife, 100, reason: 'null mileage entries ignored');
      expect(cars[0].oilKm, 0, reason: 'null mileage entries ignored');
    });
  });
}
