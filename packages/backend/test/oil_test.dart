import 'package:test/test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:backend/backend.dart';

void main() {
  group('SqliteCarRepository — oil life', () {
    late Database db;
    late SqliteCarRepository repo;
    late int carId;

    setUp(() {
      db = sqlite3.openInMemory();
      repo = SqliteCarRepository.inMemory(db);
      seedIfEmpty(db);
      repo.loadCars().then((cars) => carId = cars[0].id);
    });

    tearDown(() {
      db.close();
    });

    test('insertWorkRecord stores mileage', () async {
      final record = const WorkRecord(
        id: -1,
        description: 'Test',
        date: '2026-01-01',
        cost: 100,
        category: 'maintenance',
        mileage: 50000,
      );
      final saved = await repo.insertWorkRecord(carId, record);
      expect(saved.mileage, 50000);
    });

    test('insertWorkRecord defaults mileage to null', () async {
      final record = const WorkRecord(
        id: -1,
        description: 'Test',
        date: '2026-01-01',
        cost: 100,
        category: 'maintenance',
      );
      final saved = await repo.insertWorkRecord(carId, record);
      expect(saved.mileage, isNull);
    });

    test('loadWorkRecords returns mileage field', () async {
      await repo.insertWorkRecord(
        carId,
        const WorkRecord(
          id: -1,
          description: 'Check',
          date: '2026-01-01',
          cost: 50,
          category: 'maintenance',
          mileage: 30000,
        ),
      );
      final records = await repo.loadWorkRecords(carId);
      final match = records.where((r) => r.description == 'Check').first;
      expect(match.mileage, 30000);
    });

    test('updateWorkRecord persists mileage', () async {
      final records = await repo.loadWorkRecords(carId);
      final original = records[0];
      await repo.updateWorkRecord(original.copyWith(mileage: 99999));
      final reloaded = await repo.loadWorkRecords(carId);
      final match = reloaded.firstWhere((r) => r.id == original.id);
      expect(match.mileage, 99999);
    });
  });
}
