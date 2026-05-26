import 'package:test/test.dart';
import 'package:backend/backend.dart';

class _MockRepo implements CarRepository {
  final List<Car> _cars = [];
  int _nextId = 1;
  int _nextWorkId = 1;

  @override
  Future<List<Car>> loadCars() async => List.unmodifiable(_cars);
  @override
  Future<Car> insertCar(Car car) async {
    final saved = car.copyWith(id: _nextId++);
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
  Future<void> deleteCar(int carId) async => _cars.removeWhere((c) => c.id == carId);
  @override
  Future<List<WorkRecord>> loadWorkRecords(int carId) async => [];
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
  Future<void> deleteWorkRecord(int carId, int workId) async {}
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

Car _makeCar({
  int id = 1,
  String make = 'BMW',
  String model = 'X5',
  int year = 2020,
  String plate = 'A123BC',
  String colorHex = '#1e3a8a',
  int price = 45000,
  int mileage = 45000,
  int oilLife = 65,
  int oilKm = 4500,
  int oilMax = 10000,
  List<WorkRecord> works = const [],
}) => Car(
  id: id,
  make: make,
  model: model,
  year: year,
  plate: plate,
  colorHex: colorHex,
  price: price,
  mileage: mileage,
  oilLife: oilLife,
  oilKm: oilKm,
  oilMax: oilMax,
  works: works,
);

WorkRecord _makeWork({
  int id = 1,
  String description = 'Oil change',
  String date = '2026-04-12',
  int cost = 189,
  String category = 'maintenance',
  int? mileage,
}) => WorkRecord(
  id: id,
  description: description,
  date: date,
  cost: cost,
  category: category,
  mileage: mileage,
);

void main() {
  group('exportCsv', () {
    test('produces header for empty repo', () async {
      final repo = _MockRepo();
      final csv = await exportCsv(repo);
      expect(
        csv,
        'make,model,year,plate,color_hex,price,mileage,oil_life,oil_km,oil_max,'
        'description,date,cost,category,work_mileage',
      );
    });

    test('exports single car with work records', () async {
      final repo = _MockRepo();
      await repo.insertCar(_makeCar(works: [_makeWork()]));
      final csv = await exportCsv(repo);
      final lines = csv.split('\n');
      expect(lines.length, 2);
      expect(
        lines[1],
        'BMW,X5,2020,A123BC,#1e3a8a,45000,45000,65,4500,10000,'
        'Oil change,2026-04-12,189,maintenance,',
      );
    });

    test('exports car with no work records (empty work fields)', () async {
      final repo = _MockRepo();
      await repo.insertCar(_makeCar(works: []));
      final csv = await exportCsv(repo);
      final line = csv.split('\n')[1];
      expect(line, 'BMW,X5,2020,A123BC,#1e3a8a,45000,45000,65,4500,10000,,,,,');
    });

    test('escapes commas and quotes in fields', () async {
      final repo = _MockRepo();
      await repo.insertCar(
        _makeCar(
          make: 'Ford, Inc.',
          model: 'F-150 "Raptor"',
          works: [_makeWork(description: 'Repair, fix & "tune"')],
        ),
      );
      final csv = await exportCsv(repo);
      final line = csv.split('\n')[1];
      expect(line, contains('"Ford, Inc."'));
      expect(line, contains('"F-150 ""Raptor"""'));
      expect(line, contains('"Repair, fix & ""tune"""'));
    });

    test('exports multiple cars with multiple work records', () async {
      final repo = _MockRepo();
      final c1 = await repo.insertCar(_makeCar(plate: 'A1'));
      final c2 = await repo.insertCar(_makeCar(make: 'Toyota', plate: 'A2'));
      await repo.insertWorkRecord(c1.id, _makeWork(description: 'Oil'));
      await repo.insertWorkRecord(c1.id, _makeWork(id: 2, description: 'Tires'));
      await repo.insertWorkRecord(c2.id, _makeWork(id: 3, description: 'Brakes'));
      final csv = await exportCsv(repo);
      final lines = csv.split('\n').where((l) => l.trim().isNotEmpty).toList();
      expect(lines.length, 4);
    });
  });

  group('parseCsv', () {
    test('returns empty for empty string', () {
      final result = parseCsv('');
      expect(result.cars, isEmpty);
      expect(result.works, isEmpty);
    });

    test('returns empty for header only', () {
      final result = parseCsv(
        'make,model,year,plate,color_hex,price,mileage,oil_life,oil_km,oil_max,'
        'description,date,cost,category,work_mileage',
      );
      expect(result.cars, isEmpty);
      expect(result.works, isEmpty);
    });

    test('parses single car with work records', () {
      final csv =
          'make,model,year,plate,color_hex,price,mileage,oil_life,oil_km,oil_max,'
          'description,date,cost,category,work_mileage\n'
          'BMW,X5,2020,A123BC,#1e3a8a,45000,45000,65,4500,10000,'
          'Oil change,2026-04-12,189,maintenance,5000';
      final result = parseCsv(csv);
      expect(result.cars.length, 1);
      expect(result.cars[0].make, 'BMW');
      expect(result.cars[0].plate, 'A123BC');
      expect(result.works.length, 1);
      expect(result.works[0].work.description, 'Oil change');
      expect(result.works[0].work.mileage, 5000);
    });

    test('parses car with no work records', () {
      final csv =
          'make,model,year,plate,color_hex,price,mileage,oil_life,oil_km,oil_max,'
          'description,date,cost,category,work_mileage\n'
          'BMW,X5,2020,A123BC,#1e3a8a,45000,45000,65,4500,10000,,,,,';
      final result = parseCsv(csv);
      expect(result.cars.length, 1);
      expect(result.cars[0].plate, 'A123BC');
      expect(result.works, isEmpty);
    });

    test('deduplicates cars by plate', () {
      final csv =
          'make,model,year,plate,color_hex,price,mileage,oil_life,oil_km,oil_max,'
          'description,date,cost,category,work_mileage\n'
          'BMW,X5,2020,A123BC,#1e3a8a,45000,45000,65,4500,10000,'
          'Oil change,2026-04-12,189,maintenance,5000\n'
          'BMW,X5,2020,A123BC,#1e3a8a,45000,45000,65,4500,10000,'
          'Tires,2026-05-01,320,tires,8000';
      final result = parseCsv(csv);
      expect(result.cars.length, 1);
      expect(result.works.length, 2);
    });

    test('handles quoted fields with commas', () {
      final csv =
          'make,model,year,plate,color_hex,price,mileage,oil_life,oil_km,oil_max,'
          'description,date,cost,category,work_mileage\n'
          '"Ford, Inc.","F-150 ""Raptor""",2020,A123BC,#1e3a8a,45000,45000,65,4500,10000,'
          '"Repair, fix & ""tune""",2026-04-12,189,maintenance,5000';
      final result = parseCsv(csv);
      expect(result.cars[0].make, 'Ford, Inc.');
      expect(result.cars[0].model, 'F-150 "Raptor"');
      expect(result.works[0].work.description, 'Repair, fix & "tune"');
    });
  });

  group('importCsv', () {
    test('imports cars and work records into empty repo', () async {
      final repo = _MockRepo();
      final csv =
          'make,model,year,plate,color_hex,price,mileage,oil_life,oil_km,oil_max,'
          'description,date,cost,category,work_mileage\n'
          'BMW,X5,2020,A123BC,#1e3a8a,45000,45000,65,4500,10000,'
          'Oil change,2026-04-12,189,maintenance,5000';
      await importCsv(repo, csv);
      final cars = await repo.loadCars();
      expect(cars.length, 1);
      expect(cars[0].plate, 'A123BC');
      expect(cars[0].works.length, 1);
      expect(cars[0].works[0].description, 'Oil change');
    });

    test('clears existing data before import', () async {
      final repo = _MockRepo();
      await repo.insertCar(_makeCar(plate: 'OLD001'));
      final csv =
          'make,model,year,plate,color_hex,price,mileage,oil_life,oil_km,oil_max,'
          'description,date,cost,category,work_mileage\n'
          'BMW,X5,2020,NEW001,#1e3a8a,45000,45000,65,4500,10000,,,,,';
      await importCsv(repo, csv);
      final cars = await repo.loadCars();
      expect(cars.length, 1);
      expect(cars[0].plate, 'NEW001');
    });

    test('round-trip: export then import produces same data', () async {
      final repo = _MockRepo();
      final c1 = await repo.insertCar(_makeCar(plate: 'A1'));
      await repo.insertWorkRecord(c1.id, _makeWork(description: 'Oil'));
      await repo.insertWorkRecord(c1.id, _makeWork(id: 2, description: 'Tires'));
      await repo.insertCar(_makeCar(make: 'Toyota', plate: 'A2', works: []));

      final csv = await exportCsv(repo);
      final repo2 = _MockRepo();
      await importCsv(repo2, csv);

      final cars = await repo2.loadCars();
      expect(cars.length, 2);
      final bmw = cars.firstWhere((c) => c.plate == 'A1');
      final toyota = cars.firstWhere((c) => c.plate == 'A2');
      expect(bmw.works.length, 2);
      expect(toyota.works, isEmpty);
    });
  });
}
