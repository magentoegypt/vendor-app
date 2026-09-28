import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/pref_keys.dart';
import 'api_url_helpers.dart';
import 'shared_preferences_helpers.dart';

/// The seller's token for a request, renewed while the app is in use.
///
/// Seller tokens live an hour, and sellers log in with a WhatsApp code, so
/// the app cannot sign in again by itself: sellers were logged out every
/// hour. Once a token is [refreshAfter] old, the next request first swaps it
/// for a new one (POST /V1/vendors/me/token/refresh). A seller who keeps
/// using the app stays in; one who leaves it idle for the hour is logged out
/// as before.
///
/// A refresh revokes all of the seller's older tokens, which also signs the
/// seller out on any other phone. Only one runs at a time: requests made
/// meanwhile wait for it and use the new token.
class SessionToken {
  SessionToken._();

  static const refreshAfter = Duration(minutes: 30);

  static Future<String?>? _refreshing;

  /// Stores a token the seller has just been given, and when.
  static Future<void> save(String token, {DateTime? now}) async {
    final prefs = SharedPreferencesHelpers();
    await prefs.setStringData(key: authTokenPrefKey, text: token);
    await prefs.setIntData(
        key: authTokenIssuedAtPrefKey,
        id: (now ?? DateTime.now()).millisecondsSinceEpoch);
  }

  /// The token to send, refreshed first once it is [refreshAfter] old. A
  /// session from before issue times were kept is refreshed on first use.
  static Future<String?> current({http.Client? client, DateTime? now}) async {
    final prefs = SharedPreferencesHelpers();
    final token = await prefs.getStringData(key: authTokenPrefKey);
    if (token == null || token.isEmpty) return token;
    final issuedAt = await prefs.getIntData(key: authTokenIssuedAtPrefKey);
    if (issuedAt != null &&
        (now ?? DateTime.now())
                .difference(DateTime.fromMillisecondsSinceEpoch(issuedAt)) <
            refreshAfter) {
      return token;
    }
    // A block body: an arrow would hand back this same future, and
    // whenComplete would wait for itself.
    return _refreshing ??=
        _refresh(token, client ?? http.Client(), now).whenComplete(() {
      _refreshing = null;
    });
  }

  /// Keeps the current token when the refresh fails: offline, it may still
  /// work; expired, the request's own 401 ends the session as usual.
  static Future<String?> _refresh(
      String token, http.Client client, DateTime? now) async {
    try {
      final response = await client.post(
        Uri.parse(vendorTokenRefreshApi),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode != 200) return token;
      final fresh = _tokenIn(response.body);
      if (fresh == null) return token;
      await save(fresh, now: now);
      return fresh;
    } catch (_) {
      return token;
    }
  }

  /// The login endpoints' shape: a JSON string, or an object with "token".
  static String? _tokenIn(String body) {
    try {
      final decoded = json.decode(body);
      final token = decoded is Map ? decoded['token'] : decoded;
      return token is String && token.isNotEmpty ? token : null;
    } catch (_) {
      return null;
    }
  }
}
