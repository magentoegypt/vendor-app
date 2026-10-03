/// A product's text in each store view: its name, short and long description.
///
/// [defaults] are the store-wide values (store 0). The main form edits them,
/// and the English store shows them. Each of [stores] (the Arabic store view)
/// has its own values, null where it shows the default.
///
/// From GET /V1/vendors/product/:sku/translations. Without a SKU, for a new
/// product, the same fields and store views come with every value null.
class ProductTranslations {
  ProductTranslations({required this.defaults, required this.stores});

  final Map<String, String?> defaults;
  final List<StoreTranslation> stores;

  /// The fields that have a text per store view.
  Iterable<String> get attributeCodes => defaults.keys;

  factory ProductTranslations.fromJson(Map<String, dynamic> json) {
    return ProductTranslations(
      defaults: _values(json['default_values']),
      stores: [
        for (final store in json['stores'] as List? ?? const [])
          if (store is Map<String, dynamic>) StoreTranslation.fromJson(store),
      ],
    );
  }
}

/// One store view's own text, e.g. the Arabic store's.
class StoreTranslation {
  StoreTranslation({
    required this.code,
    required this.values,
    this.name,
    this.locale,
  });

  final String code;
  final String? name;
  final String? locale;
  final Map<String, String?> values;

  /// The language of the store's text: "ar" for ar_SA.
  String get languageCode => (locale ?? code).split('_').first.toLowerCase();

  factory StoreTranslation.fromJson(Map<String, dynamic> json) {
    return StoreTranslation(
      code: json['store_code']?.toString() ?? '',
      name: json['store_name']?.toString(),
      locale: json['locale']?.toString(),
      values: _values(json['values']),
    );
  }
}

/// [{"attribute_code": "name", "value": "..."}] as {"name": "..."}.
Map<String, String?> _values(dynamic entries) => {
      for (final entry in entries as List? ?? const [])
        if (entry is Map && entry['attribute_code'] != null)
          entry['attribute_code'].toString(): entry['value']?.toString(),
    };

/// A text as compared and sent: trimmed, and null when empty. For a store
/// view, null means it has no text of its own and shows the default.
String? translationText(String? value) {
  final text = value?.trim() ?? '';
  return text.isEmpty ? null : text;
}

/// The PUT body's `translations`: per store view, the fields whose text the
/// vendor changed from [loaded]. [typed] holds the form's text by store code,
/// then by attribute code. An emptied field goes as null, which drops the
/// store's own text so that it shows the default again.
List<Map<String, dynamic>> translationChanges(
    ProductTranslations loaded, Map<String, Map<String, String>> typed) {
  final changes = <Map<String, dynamic>>[];
  for (final store in loaded.stores) {
    final values = [
      for (final code in loaded.attributeCodes)
        if (typed[store.code]?.containsKey(code) ?? false)
          if (translationText(typed[store.code]![code]) != translationText(store.values[code]))
            {'attribute_code': code, 'value': translationText(typed[store.code]![code])},
    ];
    if (values.isNotEmpty) {
      changes.add({'store_code': store.code, 'values': values});
    }
  }
  return changes;
}

/// Of the [sent] changes, those the server's [reply] still shows with the old
/// text. On a live product they wait for the admin, as other edits do.
List<({String store, String code})> translationsAwaitingApproval(
    List<Map<String, dynamic>> sent, ProductTranslations reply) {
  final waiting = <({String store, String code})>[];
  for (final change in sent) {
    final store = change['store_code'] as String;
    final live = reply.stores.where((s) => s.code == store).firstOrNull;
    for (final value in change['values'] as List) {
      final code = value['attribute_code'] as String;
      if (translationText(live?.values[code]) != translationText(value['value'] as String?)) {
        waiting.add((store: store, code: code));
      }
    }
  }
  return waiting;
}
