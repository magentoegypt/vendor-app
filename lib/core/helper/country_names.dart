import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_constants.dart';
import 'api_url_helpers.dart';

/// Country names in the app language for addresses, which only carry the code
/// ("EG"). They come from Magento's anonymous /V1/directory/countries, whose
/// full_name_locale follows the store view (/rest/ar gives Arabic), and are
/// loaded once per language.
class CountryNames {
  CountryNames._();

  static final Map<String, Map<String, String>> _byLanguage = {};
  static final Map<String, Future<void>> _loading = {};

  /// The name of [countryId] in the app language, or null until loaded (or
  /// when the store does not know it): addresses then show the code.
  static String? of(String? countryId) =>
      countryId == null ? null : _byLanguage[selectedLanguage]?[countryId];

  static Future<void> load({http.Client? client}) {
    final language = selectedLanguage;
    if (_byLanguage.containsKey(language)) return Future.value();
    // A block body: an arrow would return the removed future, which is this
    // one, and whenComplete would wait for itself forever.
    return _loading[language] ??= _fetch(language, client ?? http.Client())
        .whenComplete(() {
      _loading.remove(language);
    });
  }

  static Future<void> _fetch(String language, http.Client client) async {
    try {
      final response = await client.get(
          Uri.parse('$apiBaseUrl/rest/$language/V1/directory/countries'));
      if (response.statusCode != 200) return;
      final body = json.decode(response.body);
      if (body is! List) return;
      _byLanguage[language] = {
        for (final country in body)
          if (country is Map && country['id'] != null)
            '${country['id']}': '${country['full_name_locale'] ?? country['full_name_english'] ?? country['id']}',
      };
    } catch (_) {
      // Offline or an unexpected reply: addresses keep the country code.
    }
  }
}
