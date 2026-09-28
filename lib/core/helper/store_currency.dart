import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_constants.dart';
import '../config/pref_keys.dart';
import '../utils/money.dart';
import 'api_url_helpers.dart';
import 'shared_preferences_helpers.dart';

/// Loads the store's display currency into [Money]. Product prices and order
/// totals are shown in it; the app used to hard-code EGP while the store
/// sells in AED.
class StoreCurrency {
  StoreCurrency._();

  /// Uses what was saved last time straight away, then asks the store
  /// (anonymous /V1/directory/currency, in the app language so the symbol is
  /// too). [onChanged] runs whenever what is in use changes, so screens can
  /// redraw.
  static Future<void> load(
      {http.Client? client, void Function()? onChanged}) async {
    final prefs = SharedPreferencesHelpers();
    if (Money.storeCurrency == null) {
      final saved = await prefs.getStringData(key: storeCurrencyPrefKey);
      if ((saved ?? '').isNotEmpty) {
        Money.storeCurrency = saved;
        Money.storeCurrencySymbol =
            await prefs.getStringData(key: storeCurrencySymbolPrefKey);
        onChanged?.call();
      }
    }
    try {
      final url = '$apiBaseUrl/rest/$selectedLanguage/V1/directory/currency';
      final response = await (client ?? http.Client()).get(Uri.parse(url));
      if (response.statusCode != 200) return;
      final body = json.decode(response.body);
      if (body is! Map) return;
      final code = (body['default_display_currency_code'] ??
              body['base_currency_code'])
          ?.toString();
      final symbol = (body['default_display_currency_symbol'] ??
              body['base_currency_symbol'])
          ?.toString();
      if (code == null || code.isEmpty) return;
      if (code == Money.storeCurrency && symbol == Money.storeCurrencySymbol) {
        return;
      }
      Money.storeCurrency = code;
      Money.storeCurrencySymbol = symbol;
      await prefs.setStringData(key: storeCurrencyPrefKey, text: code);
      await prefs.setStringData(
          key: storeCurrencySymbolPrefKey, text: symbol ?? '');
      onChanged?.call();
    } catch (_) {
      // Offline or unexpected reply: keep what was saved.
    }
  }
}
