import 'dart:convert';
import 'dart:typed_data';

import 'package:backend/backend.dart';

const _csvHeader =
    'make,model,year,plate,color_hex,price,mileage,oil_life,oil_km,oil_max,'
    'description,date,cost,category,work_mileage';

const _carFieldCount = 10;

const kBackupFileName = 'garage_backup.csv';

String _esc(String v) {
  if (v.contains(',') || v.contains('"') || v.contains('\n') || v.contains('\r')) {
    return '"${v.replaceAll('"', '""')}"';
  }
  return v;
}

List<String> _split(String line) {
  final result = <String>[];
  var buf = StringBuffer();
  var q = false;
  for (var i = 0; i < line.length; i++) {
    final c = line[i];
    if (q) {
      if (c == '"') {
        if (i + 1 < line.length && line[i + 1] == '"') {
          buf.write('"');
          i++;
        } else {
          q = false;
        }
      } else {
        buf.write(c);
      }
    } else if (c == '"') {
      q = true;
    } else if (c == ',') {
      result.add(buf.toString());
      buf = StringBuffer();
    } else {
      buf.write(c);
    }
  }
  result.add(buf.toString());
  return result;
}

Future<String> exportCsv(CarRepository repo) async {
  final cars = await repo.loadCars();
  final lines = <String>[_csvHeader];
  for (final c in cars) {
    final cf = [
      c.make,
      c.model,
      c.year.toString(),
      c.plate,
      c.colorHex,
      c.price.toString(),
      c.mileage.toString(),
      c.oilLife.toString(),
      c.oilKm.toString(),
      c.oilMax.toString(),
    ].map(_esc).join(',');
    if (c.works.isEmpty) {
      lines.add('$cf,${List.filled(5, '').map(_esc).join(',')}');
    } else {
      for (final w in c.works) {
        final wf = [
          w.description,
          w.date,
          w.cost.toString(),
          w.category,
          w.mileage?.toString() ?? '',
        ].map(_esc).join(',');
        lines.add('$cf,$wf');
      }
    }
  }
  return lines.join('\n');
}

({List<Car> cars, List<({Car car, WorkRecord work})> works}) parseCsv(String csv) {
  final lines = csv.split('\n').where((l) => l.trim().isNotEmpty).toList();
  if (lines.length < 2) return (cars: [], works: []);

  int gi(List<String> f, int i) {
    final v = i < f.length ? f[i].trim() : '';
    return v.isEmpty ? 0 : int.parse(v);
  }

  final carRows = <String, List<String>>{};
  final workRows = <List<String>>[];

  for (var i = 1; i < lines.length; i++) {
    final f = _split(lines[i].trim());
    if (f.length <= _carFieldCount || f.sublist(_carFieldCount).every((s) => s.trim().isEmpty)) {
      if (f.length > 3 && f[3].trim().isNotEmpty) carRows.putIfAbsent(f[3].trim(), () => f);
    } else {
      final plate = f[3].trim();
      if (plate.isNotEmpty) {
        carRows.putIfAbsent(plate, () => f.sublist(0, _carFieldCount));
        workRows.add(f);
      }
    }
  }

  final cars = <Car>[];
  final plateIdx = <String, int>{};
  for (final e in carRows.entries) {
    final f = e.value;
    cars.add(
      Car(
        id: 0,
        make: f[0].trim(),
        model: f[1].trim(),
        year: gi(f, 2),
        plate: e.key,
        colorHex: f.length > 4 ? f[4].trim() : '#000000',
        price: gi(f, 5),
        mileage: gi(f, 6),
        oilLife: gi(f, 7),
        oilKm: gi(f, 8),
        oilMax: gi(f, 9),
      ),
    );
    plateIdx[e.key] = cars.length - 1;
  }

  final works = <({Car car, WorkRecord work})>[];
  for (final f in workRows) {
    final ci = plateIdx[f[3].trim()];
    if (ci == null) continue;
    final mv = f.length > 14 ? f[14].trim() : '';
    works.add((
      car: cars[ci],
      work: WorkRecord(
        id: -1,
        description: f.length > 10 ? f[10].trim() : '',
        date: f.length > 11 ? f[11].trim() : '',
        cost: gi(f, 12),
        category: f.length > 13 ? f[13].trim() : '',
        mileage: mv.isEmpty ? null : int.tryParse(mv),
      ),
    ));
  }

  return (cars: cars, works: works);
}

Future<void> importCsv(CarRepository repo, String csv) async {
  final p = parseCsv(csv);
  if (p.cars.isEmpty) return;

  await repo.clearAll();

  final byPlate = <String, Car>{};
  for (final c in p.cars) {
    byPlate[c.plate] = await repo.insertCar(c);
  }

  for (final e in p.works) {
    final car = byPlate[e.car.plate];
    if (car == null) continue;
    await repo.insertWorkRecord(car.id, e.work);
  }
}

Future<Uint8List> exportCsvBytes(CarRepository repo) async =>
    Uint8List.fromList(utf8.encode(await exportCsv(repo)));

Future<void> importCsvBytes(CarRepository repo, Uint8List bytes) async =>
    importCsv(repo, utf8.decode(bytes));
