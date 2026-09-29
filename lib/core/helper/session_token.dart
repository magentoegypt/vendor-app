import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/pref_keys.dart';
import 'api_url_helpers.dart';
import 'shared_preferences_helpers.dart';

/// The seller's token for a request, renewed while the app is in use.
///
/// Seller tokens live 24 hours (one hour until 2026-09-28), and sellers log
/// in with a WhatsApp code, so the app cannot sign in again by itself. Once a
/// token is halfway through its life, 12 hours for a 24-hour token, the next
/// request first swaps it for a new one (POST /V1/vendors/me/token/refresh).
/// A seller who opens the app at least once a day stays in; one who stays
/// away longer than the token's life logs in again.
///
/// A refresh leaves the seller's other tokens working, so other phones stay
/// signed in. Only one runs at a time: requests made meanwhile wait for it
/// and use the new token.
class SessionToken {
  SessionToken._();

  /// A token's life when neither the token nor the app records it: the
  /// backend's setting since 2026-09-28.
  static const defaultLifetime = Duration(hours: 24);

  static Future<String?>? _refreshing;

  /// Stores a token the seller has just been given, and when.
  static Future<void> save(String token, {DateTime? now}) async {
    final prefs = SharedPreferencesHelpers();
    await prefs.setStringData(key: authTokenPrefKey, text: token);
    await prefs.setIntData(
        key: authTokenIssuedAtPrefKey,
        id: (now ?? DateTime.now()).millisecondsSinceEpoch);
  }

  /// The token to send, refreshed first once half of its life has passed.
  /// Its life runs from the JWT's "iat" (or else when the app saved it) to
  /// its "exp" (or else [defaultLifetime] after saving); a token with none
  /// of these is refreshed on first use.
  static Future<String?> current({http.Client? client, DateTime? now}) async {
    final prefs = SharedPreferencesHelpers();
    final token = await prefs.getStringData(key: authTokenPrefKey);
    if (token == null || token.isEmpty) return token;
    final claims = _claims(token);
    final savedAt = await _savedAt(prefs);
    final issuedAt = _time(claims['iat']) ?? savedAt;
    final expiresAt = _time(claims['exp']) ?? savedAt?.add(defaultLifetime);
    if (expiresAt != null) {
      final left = expiresAt.difference(now ?? DateTime.now());
      final life = issuedAt == null
          ? defaultLifetime
          : expiresAt.difference(issuedAt);
      // Past its expiry a token can only be refused, so it is not sent to be
      // refreshed: the request's own 401 sends the seller to log in.
      if (left <= Duration.zero || left > life ~/ 2) return token;
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

  /// The claims of a seller token (a JWT), or none for anything else.
  static Map _claims(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return const {};
    try {
      final payload = json.decode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
      return payload is Map ? payload : const {};
    } catch (_) {
      return const {};
    }
  }

  /// A JWT time claim, in seconds since the epoch.
  static DateTime? _time(Object? seconds) => seconds is num
      ? DateTime.fromMillisecondsSinceEpoch((seconds * 1000).round())
      : null;

  static Future<DateTime?> _savedAt(SharedPreferencesHelpers prefs) async {
    final savedAt = await prefs.getIntData(key: authTokenIssuedAtPrefKey);
    return savedAt == null ? null : DateTime.fromMillisecondsSinceEpoch(savedAt);
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
