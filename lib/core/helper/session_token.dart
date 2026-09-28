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

  static const lifetime = Duration(minutes: 60);
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

  /// The token to send, refreshed first once it is [refreshAfter] old. Its
  /// age comes from the JWT's own expiry, or else from when it was saved; a
  /// token with neither is refreshed on first use.
  static Future<String?> current({http.Client? client, DateTime? now}) async {
    final prefs = SharedPreferencesHelpers();
    final token = await prefs.getStringData(key: authTokenPrefKey);
    if (token == null || token.isEmpty) return token;
    final expiresAt = _expiry(token) ?? await _expiryFromSave(prefs);
    if (expiresAt != null) {
      final left = expiresAt.difference(now ?? DateTime.now());
      // Past its hour a token can only be refused, so it is not sent to be
      // refreshed: the request's own 401 sends the seller to log in.
      if (left <= Duration.zero || left > lifetime - refreshAfter) return token;
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

  /// When a seller token expires, from the "exp" claim of the JWT.
  static DateTime? _expiry(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    try {
      final payload = json.decode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
      final exp = payload is Map ? payload['exp'] : null;
      return exp is num
          ? DateTime.fromMillisecondsSinceEpoch((exp * 1000).round())
          : null;
    } catch (_) {
      return null;
    }
  }

  static Future<DateTime?> _expiryFromSave(SharedPreferencesHelpers prefs) async {
    final issuedAt = await prefs.getIntData(key: authTokenIssuedAtPrefKey);
    return issuedAt == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(issuedAt).add(lifetime);
  }

  /// The refresh endpoint answers with a JSON string; an object with "token"
  /// (the OTP login's shape) is read too.
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
