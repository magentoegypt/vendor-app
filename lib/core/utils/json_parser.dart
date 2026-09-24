import '../config/extensions.dart';

/// Lenient readers for values decoded from API JSON.
///
/// Magento returns its decimal columns (prices, totals, qty, weight) as JSON
/// floats such as `2.0` or `149.95`, and some ids arrive as strings. Assigning
/// those straight to an `int?` or `String?` field throws, and one bad field
/// fails the whole model, so models read every value through these helpers.
class JsonParser {
  JsonParser._();

  static int? toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      final text = value.trim();
      return int.tryParse(text) ?? double.tryParse(text)?.toInt();
    }
    if (value is bool) return value ? 1 : 0;
    return null;
  }

  static num? toNum(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value.trim());
    if (value is bool) return value ? 1 : 0;
    return null;
  }

  static double? toDouble(dynamic value) => toNum(value)?.toDouble();

  static String? toStr(dynamic value) {
    if (value is String) return value;
    if (value is num || value is bool) return value.toString();
    return null;
  }

  static bool? toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      switch (value.trim().toLowerCase()) {
        case 'true':
        case '1':
          return true;
        case 'false':
        case '0':
        case '':
          return false;
      }
    }
    return null;
  }

  static List<String>? toStringList(dynamic value) {
    if (value is List) {
      return value.where((e) => e != null).map((e) => e.toString()).toList();
    }
    if (value is String) return [value];
    return null;
  }

  /// Parses [value] with [fromJson] when it is a JSON object, otherwise null.
  /// PHP encodes an empty object as `[]`, which must not reach [fromJson].
  static T? toObject<T>(
      dynamic value, T Function(Map<String, dynamic> json) fromJson) {
    return value is Map<String, dynamic> ? fromJson(value) : null;
  }

  /// Parses each object in [value] with [fromJson]. An element that fails to
  /// parse is logged and skipped, so one malformed row cannot empty a list.
  static List<T>? toList<T>(
      dynamic value, T Function(Map<String, dynamic> json) fromJson) {
    if (value is! List) return null;
    final items = <T>[];
    for (final element in value) {
      if (element is! Map<String, dynamic>) continue;
      try {
        items.add(fromJson(element));
      } catch (exception, stackTrace) {
        'Skipped unparseable $T: $exception\n$stackTrace'.log();
      }
    }
    return items;
  }
}
