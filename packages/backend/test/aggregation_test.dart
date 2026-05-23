// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:test/test.dart';
import 'package:backend/backend.dart';

void main() {
  final now = DateTime(2026, 5, 10);
  final car = const Car(
    id: 3,
    make: 'Mercedes',
    model: 'C-Class',
    year: 2019,
    plate: 'X789FG',
    colorHex: '#1a1a1a',
    price: 35000,
    mileage: 62000,
    oilLife: 18,
    oilKm: 10500,
    oilMax: 12000,
    works: const [
      WorkRecord(
        id: 10,
        description: 'Transmission service',
        date: '2026-03-15',
        cost: 580,
        category: 'repair',
      ),
      WorkRecord(
        id: 11,
        description: 'Oil change',
        date: '2026-02-20',
        cost: 150,
        category: 'maintenance',
      ),
      WorkRecord(
        id: 12,
        description: 'Brake rotors rear',
        date: '2026-01-08',
        cost: 670,
        category: 'replacement',
      ),
      WorkRecord(
        id: 13,
        description: 'Wheel alignment',
        date: '2025-12-22',
        cost: 120,
        category: 'tires',
      ),
      WorkRecord(
        id: 14,
        description: 'Spark plugs',
        date: '2025-11-10',
        cost: 340,
        category: 'replacement',
      ),
      WorkRecord(
        id: 15,
        description: 'Road tax 2026',
        date: '2026-03-01',
        cost: 350,
        category: 'tax',
      ),
    ],
  );

  group('getMonthYearSpending', () {
    test('returns 0 when month has no works', () {
      // offset -2 = July 2026, no works
      expect(getMonthYearSpending(car, -2, now), 0);
    });

    test('returns correct spending for March 2026 (offset 2)', () {
      // offset 2 from May 2026 = March 2026
      // Mercedes works in March: Transmission service (580) + Road tax (350) = 930
      expect(getMonthYearSpending(car, 2, now), 930);
    });

    test('returns correct spending for February 2026 (offset 3)', () {
      // offset 3 = Feb 2026: Oil change (150)
      expect(getMonthYearSpending(car, 3, now), 150);
    });

    test('returns correct spending for January 2026 (offset 4)', () {
      // offset 4 = Jan 2026: Brake rotors rear (670)
      expect(getMonthYearSpending(car, 4, now), 670);
    });

    test('handles year boundary (December 2025, offset 5)', () {
      // offset 5 = Dec 2025: Wheel alignment (120)
      expect(getMonthYearSpending(car, 5, now), 120);
    });

    test('handles year boundary (November 2025, offset 6)', () {
      // offset 6 = Nov 2025: Spark plugs (340)
      expect(getMonthYearSpending(car, 6, now), 340);
    });
  });

  group('getMonthYearWorkCount', () {
    test('returns 0 when month has no works', () {
      expect(getMonthYearWorkCount(car, -2, now), 0);
    });

    test('counts works in March 2026 (offset 2)', () {
      expect(getMonthYearWorkCount(car, 2, now), 2);
    });

    test('counts works in a month with 1 record', () {
      expect(getMonthYearWorkCount(car, 3, now), 1);
    });

    test('handles year boundary', () {
      expect(getMonthYearWorkCount(car, 5, now), 1);
    });

    test('works without explicit now (uses DateTime.now())', () {
      expect(getMonthYearWorkCount(car, 0), isA<int>());
    });
  });
}
