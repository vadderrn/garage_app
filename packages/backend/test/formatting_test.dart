// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:test/test.dart';
import 'package:backend/backend.dart';

void main() {
  group('IntFormat', () {
    test('formats small numbers without commas', () {
      expect(0.formatNum(), '0');
      expect(1.formatNum(), '1');
      expect(999.formatNum(), '999');
    });

    test('formats thousands with commas', () {
      expect(1000.formatNum(), '1,000');
      expect(12345.formatNum(), '12,345');
      expect(1234567.formatNum(), '1,234,567');
    });

    test('formatCompact shows K for thousands', () {
      expect(1000.formatCompact(), '1K');
      expect(45000.formatCompact(), '45K');
      expect(1234.formatCompact(), '1.2K');
    });

    test('formatCompact shows M for millions', () {
      expect(1000000.formatCompact(), '1M');
      expect(2500000.formatCompact(), '2.5M');
      expect(12300000.formatCompact(), '12.3M');
    });

    test('formatCompact shows plain number under 1000', () {
      expect(0.formatCompact(), '0');
      expect(500.formatCompact(), '500');
      expect(999.formatCompact(), '999');
    });
  });

  group('formatCurrency', () {
    test('formats USD correctly', () {
      expect(formatCurrency(45000, 'usd'), r'$45K');
      expect(formatCurrency(100, 'usd'), r'$100');
      expect(formatCurrency(0, 'usd'), r'$0');
    });

    test('formats RUB correctly', () {
      expect(formatCurrency(45000, 'rub'), '₽4.1M');
      expect(formatCurrency(100, 'rub'), '₽9K');
    });

    test('formats EUR correctly', () {
      expect(formatCurrency(45000, 'eur'), '€41.4K');
      expect(formatCurrency(100, 'eur'), '€92');
    });

    test('falls back to USD for unknown currency', () {
      expect(formatCurrency(100, 'unknown'), r'$100');
    });
  });
}
