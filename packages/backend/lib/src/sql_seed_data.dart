// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:sqlite3/sqlite3.dart';

import 'sql_queries.dart';

void seedIfEmpty(Database db) {
  if (db.select(countCarsSQL).first['c'] as int > 0) {
    return;
  }

  db.execute("""
    INSERT INTO cars VALUES
      (1, 'BMW',      'X5',      2020, 'A123BC', '#1e3a8a', 45000, 45000, 65, 4500,  10000),
      (2, 'Toyota',   'Camry',   2022, 'M456DE', '#c0c0c0', 28000, 28000, 40, 6000,  10000),
      (3, 'Mercedes', 'C-Class', 2019, 'X789FG', '#1a1a1a', 35000, 62000, 18, 10500, 12000)
  """);

  db.execute("""
    INSERT INTO work_records (car_id, description, date, cost, category) VALUES
      (1, 'Oil change & filter', '2026-04-12', 189, 'maintenance'),
      (1, 'Summer tires swap',   '2026-04-02', 320, 'tires'),
      (1, 'Annual inspection',   '2026-03-10', 150, 'diagnostic'),
      (1, 'Brake pads front',    '2026-02-15', 470, 'repair'),
      (1, 'Cabin air filter',    '2026-01-05', 95,  'replacement'),
      (1, 'Full tank premium',   '2026-04-10', 85,  'fuel'),
      (1, 'Annual insurance',    '2026-03-15', 1200,'insurance'),
      (1, 'Premium car wash',    '2026-03-20', 45,  'cleaning')
  """);

  db.execute("""
    INSERT INTO work_records (car_id, description, date, cost, category) VALUES
      (2, 'Oil change',         '2026-04-05', 95,  'maintenance'),
      (2, 'Tire rotation',      '2026-03-20', 60,  'tires'),
      (2, 'Brake fluid flush',  '2026-02-10', 130, 'maintenance'),
      (2, 'Battery check',      '2026-01-15', 25,  'diagnostic'),
      (2, 'Gas station fill',   '2026-04-08', 65,  'fuel'),
      (2, 'Interior detailing', '2026-03-01', 80,  'cleaning')
  """);

  db.execute("""
    INSERT INTO work_records (car_id, description, date, cost, category) VALUES
      (3, 'Transmission service', '2026-03-15', 580, 'repair'),
      (3, 'Oil change',           '2026-02-20', 150, 'maintenance'),
      (3, 'Brake rotors rear',    '2026-01-08', 670, 'replacement'),
      (3, 'Wheel alignment',      '2025-12-22', 120, 'tires'),
      (3, 'Spark plugs',          '2025-11-10', 340, 'replacement'),
      (3, 'Premium diesel',       '2026-04-11', 95,  'fuel'),
      (3, 'Road tax 2026',        '2026-03-01', 350, 'tax')
  """);
}
