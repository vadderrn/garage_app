// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

extension IntFormat on int {
  String formatNum() {
    if (this < 1000) return toString();
    final s = toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
      b.write(s[i]);
    }
    return b.toString();
  }

  String formatCompact() {
    if (this >= 1000000) {
      final val = this / 1000000;
      final rounded = (val * 10).round() / 10;
      return '${rounded == rounded.roundToDouble() ? rounded.round() : rounded}M';
    }
    if (this >= 1000) {
      final val = this / 1000;
      final rounded = (val * 10).round() / 10;
      return '${rounded == rounded.roundToDouble() ? rounded.round() : rounded}K';
    }
    return toString();
  }
}

class _CurrencyInfo {
  final String symbol;
  final double rate;
  const _CurrencyInfo(this.symbol, this.rate);
}

const _currencies = <String, _CurrencyInfo>{
  'usd': _CurrencyInfo('\$', 1),
  'rub': _CurrencyInfo('\u{20BD}', 90),
  'eur': _CurrencyInfo('\u{20AC}', 0.92),
};

String formatCurrency(int usdAmount, String currencyCode) {
  final cur = _currencies[currencyCode] ?? _currencies['usd']!;
  final converted = (usdAmount * cur.rate).round();
  return '${cur.symbol}${converted.formatCompact()}';
}
