import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:timezone/data/latest_10y.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../config/app_constants.dart';
import '../config/pref_keys.dart';
import 'api_url_helpers.dart';
import 'shared_preferences_helpers.dart';

/// Order dates in the store's time, as the web panel shows them.
///
/// Magento sends created_at in UTC without a zone ("2026-09-27 23:25:58"),
/// and the store keeps its own timezone (Asia/Riyadh on Hub Market), not the
/// phone's. Shown in UTC, an order placed at 02:25 on 28 Sep in Riyadh read
/// 27 Sep.
class StoreTime {
  StoreTime._();

  /// The store's timezone from /V1/store/storeConfigs, e.g. "Asia/Riyadh".
  /// Null until loaded.
  static String? timezone;

  static bool _zonesLoaded = false;

  /// A created_at value as the date and time in the store's timezone, or in
  /// the phone's until that is known. Null when empty or unreadable.
  static DateTime? of(String? createdAt) {
    final value = createdAt?.trim() ?? '';
    if (value.isEmpty) return null;
    final instant = DateTime.tryParse('${value}Z') ?? DateTime.tryParse(value);
    if (instant == null) return null;
    final location = _location();
    return location == null
        ? instant.toLocal()
        : tz.TZDateTime.from(instant, location);
  }

  static tz.Location? _location() {
    final name = timezone;
    if (name == null || name.isEmpty) return null;
    if (!_zonesLoaded) {
      tz_data.initializeTimeZones();
      _zonesLoaded = true;
    }
    try {
      return tz.getLocation(name);
    } catch (_) {
      return null; // A name this timezone database doesn't know.
    }
  }

  /// Uses the timezone saved last time straight away, then asks the store
  /// (anonymous /V1/store/storeConfigs, the entry for this store view).
  /// [onChanged] runs whenever the timezone in use changes, so screens can
  /// redraw.
  static Future<void> load(
      {http.Client? client, void Function()? onChanged}) async {
    final prefs = SharedPreferencesHelpers();
    if (timezone == null) {
      final saved = await prefs.getStringData(key: storeTimezonePrefKey);
      if ((saved ?? '').isNotEmpty) {
        timezone = saved;
        onChanged?.call();
      }
    }
    try {
      final url = '$apiBaseUrl/rest/$selectedLanguage/V1/store/storeConfigs';
      final response = await (client ?? http.Client()).get(Uri.parse(url));
      if (response.statusCode != 200) return;
      final body = json.decode(response.body);
      if (body is! List) return;
      final configs = body.whereType<Map>().toList();
      if (configs.isEmpty) return;
      final config = configs.firstWhere(
          (c) => c['code'] == selectedLanguage,
          orElse: () => configs.first);
      final zone = config['timezone']?.toString();
      if (zone == null || zone.isEmpty || zone == timezone) return;
      timezone = zone;
      await prefs.setStringData(key: storeTimezonePrefKey, text: zone);
      onChanged?.call();
    } catch (_) {
      // Offline or unexpected reply: keep what was saved.
    }
  }
}
