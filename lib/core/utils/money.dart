import 'package:intl/intl.dart';

import 'json_parser.dart';

/// Amounts the server sends as plain numbers (order totals, product prices),
/// written the way it formats the dashboard cards: "AED 1,430.00", in Arabic
/// too, so a screen never mixes "AED" and "د.إ". Amounts the server already
/// formats (the dashboard cards) are shown as returned.
class Money {
  Money._();

  /// The store's display currency, from /V1/directory/currency. Null until
  /// loaded; amounts then show without a currency rather than a wrong one.
  static String? storeCurrency;

  static final _digits = NumberFormat('#,##0.00', 'en');

  /// [currency] is the amount's own code (an order's currency); without one
  /// the store currency is used. No currency is hard-coded.
  static String format(dynamic amount, {String? currency}) {
    final number = JsonParser.toNum(amount) ?? 0;
    final digits = _digits.format(number);
    final code = (currency ?? '').isNotEmpty ? currency! : storeCurrency;
    if (code == null || code.isEmpty) return digits;
    return '$code $digits';
  }
}
