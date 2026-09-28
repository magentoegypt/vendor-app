import 'package:intl/intl.dart';

import 'json_parser.dart';

/// Amounts the server sends as plain numbers (order totals, product prices),
/// written the way it formats its own: "AED 1,430.00" in English and
/// "1,430.00 د.إ." in Arabic. Amounts the server already formats (the
/// dashboard cards) are shown as returned.
class Money {
  Money._();

  /// The store's display currency and its symbol in the app language, both
  /// from /V1/directory/currency. Null until loaded; amounts then show
  /// without a currency rather than a wrong one.
  static String? storeCurrency;
  static String? storeCurrencySymbol;

  static final _digits = NumberFormat('#,##0.00', 'en');

  /// [currency] is the amount's own code (an order's currency); without one
  /// the store currency is used. No symbol is hard-coded: Arabic uses the
  /// store's own, and any other currency shows its code.
  static String format(dynamic amount,
      {String? currency, String language = 'en'}) {
    final number = JsonParser.toNum(amount) ?? 0;
    final digits = _digits.format(number);
    final code = (currency ?? '').isNotEmpty ? currency! : storeCurrency;
    if (code == null || code.isEmpty) return digits;
    if (language == 'ar') {
      final symbol = code == storeCurrency && (storeCurrencySymbol ?? '').isNotEmpty
          ? storeCurrencySymbol!
          : code;
      return '$digits $symbol';
    }
    return '$code $digits';
  }
}
