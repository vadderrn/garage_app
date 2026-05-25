// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

const String createTablesSQL = '''
CREATE TABLE IF NOT EXISTS cars (
  id        INTEGER PRIMARY KEY AUTOINCREMENT,
  make      TEXT NOT NULL,
  model     TEXT NOT NULL,
  year      INTEGER NOT NULL,
  plate     TEXT NOT NULL,
  color_hex TEXT NOT NULL,
  price     INTEGER NOT NULL,
  mileage   INTEGER NOT NULL,
  oil_life  INTEGER NOT NULL,
  oil_km    INTEGER NOT NULL,
  oil_max   INTEGER NOT NULL
)
''';

const String createWorkRecordsTableSQL = '''
CREATE TABLE IF NOT EXISTS work_records (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  car_id      INTEGER NOT NULL,
  description TEXT NOT NULL,
  date        TEXT NOT NULL,
  cost        INTEGER NOT NULL,
  category    TEXT NOT NULL,
  mileage     INTEGER,
  FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE CASCADE
)
''';

const String countCarsSQL = 'SELECT COUNT(*) as c FROM cars';

const String loadAllCarsSQL = '''
SELECT * FROM cars
ORDER BY id
''';

const String loadWorkRecordsSQL = '''
SELECT * FROM work_records
WHERE car_id = ?
ORDER BY id
''';

const String insertCarSQL = '''
INSERT INTO cars (make, model, year, plate, color_hex, price, mileage, oil_life, oil_km, oil_max)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
''';

const String updateCarSQL = '''
UPDATE cars SET make=?, model=?, year=?, plate=?, color_hex=?, price=?, mileage=?, oil_life=?, oil_km=?, oil_max=?
WHERE id=?
''';

const String deleteWorkRecordsByCarSQL = '''
DELETE FROM work_records WHERE car_id = ?
''';

const String deleteCarSQL = '''
DELETE FROM cars WHERE id = ?
''';

const String migrateWorkRecordsSQL = '''
ALTER TABLE work_records ADD COLUMN mileage INTEGER
''';

const String insertWorkRecordSQL = '''
INSERT INTO work_records (car_id, description, date, cost, category, mileage)
VALUES (?, ?, ?, ?, ?, ?)
''';

const String updateWorkRecordSQL = '''
UPDATE work_records SET description=?, date=?, cost=?, category=?, mileage=? WHERE id=?
''';

const String deleteWorkRecordSQL = '''
DELETE FROM work_records
WHERE id = ? AND car_id = ?
''';

const String getTotalSpentSQL = '''
SELECT COALESCE(SUM(cost), 0) as s
FROM work_records
WHERE car_id = ?
''';

const String getAvgSpentSQL = '''
SELECT COALESCE(AVG(cost), 0.0) as a
FROM work_records
WHERE car_id = ?
''';

const String getLastServiceDateSQL = '''
SELECT date FROM work_records
WHERE car_id = ?
ORDER BY date ASC LIMIT 1
''';

const String getCategoryTotalsSQL = '''
SELECT category, COALESCE(SUM(cost), 0) as total
FROM work_records
WHERE car_id = ?
GROUP BY category
''';

const String getTopCategorySQL = '''
SELECT category, COALESCE(SUM(cost), 0) as total
FROM work_records
WHERE car_id = ?
GROUP BY category
ORDER BY total DESC LIMIT 1
''';

const String getMonthYearSpendingSQL = """
SELECT COALESCE(SUM(cost), 0) as s
FROM work_records
WHERE car_id = ?
  AND strftime('%Y', date) = ?
  AND strftime('%m', date) = ?
""";

const String getMonthYearWorkCountSQL = """
SELECT COUNT(*) as c
FROM work_records
WHERE car_id = ?
  AND strftime('%Y', date) = ?
  AND strftime('%m', date) = ?
""";

const String createSettingsTableSQL = '''
CREATE TABLE IF NOT EXISTS app_settings (
  id            INTEGER PRIMARY KEY CHECK (id = 1),
  language      TEXT NOT NULL DEFAULT 'en',
  distance_unit TEXT NOT NULL DEFAULT 'km',
  theme         TEXT NOT NULL DEFAULT 'dark',
  currency      TEXT NOT NULL DEFAULT 'usd'
)
''';

const String insertDefaultSettingsSQL = '''
INSERT OR IGNORE INTO app_settings (id) VALUES (1)
''';

const String loadSettingsSQL = '''
SELECT * FROM app_settings WHERE id = 1
''';

const String updateSettingsSQL = '''
UPDATE app_settings SET language=?, distance_unit=?, theme=?, currency=? WHERE id=1
''';
