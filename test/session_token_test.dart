import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:multi_vendor/core/config/pref_keys.dart';
import 'package:multi_vendor/core/helper/session_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final issued = DateTime(2026, 9, 28, 20, 0);

  void signedIn({String token = 'old', DateTime? at}) =>
      SharedPreferences.setMockInitialValues({
        authTokenPrefKey: token,
        if (at != null) authTokenIssuedAtPrefKey: at.millisecondsSinceEpoch,
      });

  Future<String?> stored() async =>
      (await SharedPreferences.getInstance()).getString(authTokenPrefKey);

  group('Seller session (14zb93nv65d)', () {
    test('a token under 30 minutes old is sent as it is', () async {
      signedIn(at: issued);
      var calls = 0;
      final client = MockClient((_) async {
        calls++;
        return http.Response('"new"', 200);
      });

      final token = await SessionToken.current(
          client: client, now: issued.add(const Duration(minutes: 29)));

      expect(token, 'old');
      expect(calls, 0);
    });

    test('an older token is swapped first, and the new one kept', () async {
      signedIn(at: issued);
      late http.Request sent;
      final client = MockClient((request) async {
        sent = request;
        return http.Response('"new"', 200);
      });
      final now = issued.add(const Duration(minutes: 31));

      expect(await SessionToken.current(client: client, now: now), 'new');
      expect(sent.method, 'POST');
      expect(sent.url.path, '/rest/V1/vendors/me/token/refresh');
      expect(sent.headers['Authorization'], 'Bearer old');
      expect(await stored(), 'new');
      // The new token's hour starts now: no second refresh.
      expect(
          await SessionToken.current(
              client: client, now: now.add(const Duration(minutes: 5))),
          'new');
    });

    test('requests made during a refresh share it', () async {
      signedIn(at: issued);
      var calls = 0;
      final client = MockClient((_) async {
        calls++;
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return http.Response('"new"', 200);
      });
      final now = issued.add(const Duration(minutes: 45));

      final tokens = await Future.wait(
          [for (var i = 0; i < 3; i++) SessionToken.current(client: client, now: now)]);

      expect(tokens, ['new', 'new', 'new']);
      expect(calls, 1);
    });

    test('a refused refresh keeps the token: the request ends the session as before',
        () async {
      signedIn(at: issued);
      final client = MockClient((_) async => http.Response(
          '{"message":"The consumer isn\'t authorized to access %resources."}', 401));

      final token = await SessionToken.current(
          client: client, now: issued.add(const Duration(minutes: 45)));

      expect(token, 'old');
      expect(await stored(), 'old');
    });

    test('a token past its hour is not sent to refresh (it could only be refused)',
        () async {
      signedIn(at: issued);
      var calls = 0;
      final client = MockClient((_) async {
        calls++;
        return http.Response('"new"', 200);
      });

      final token = await SessionToken.current(
          client: client, now: issued.add(const Duration(minutes: 61)));

      expect(token, 'old');
      expect(calls, 0);
    });

    test("the JWT's own expiry decides, even without a saved issue time",
        () async {
      String jwt(DateTime expires) {
        String part(Object value) =>
            base64Url.encode(utf8.encode(json.encode(value))).replaceAll('=', '');
        return '${part({'alg': 'HS256'})}.'
            '${part({'uid': 51, 'exp': expires.millisecondsSinceEpoch ~/ 1000})}.sig';
      }
      var calls = 0;
      final client = MockClient((_) async {
        calls++;
        return http.Response('"new"', 200);
      });
      final now = issued.add(const Duration(minutes: 10));

      signedIn(token: jwt(now.add(const Duration(minutes: 50))));
      expect(await SessionToken.current(client: client, now: now), isNot('new'));
      expect(calls, 0);

      signedIn(token: jwt(now.add(const Duration(minutes: 20))));
      expect(await SessionToken.current(client: client, now: now), 'new');
      expect(calls, 1);

      signedIn(token: jwt(now.subtract(const Duration(minutes: 1))));
      expect(await SessionToken.current(client: client, now: now), isNot('new'));
      expect(calls, 1);
    });

    test('a session from before issue times were kept is refreshed on first use',
        () async {
      signedIn();
      final client =
          MockClient((_) async => http.Response('{"token":"new"}', 200));

      expect(await SessionToken.current(client: client), 'new');
    });

    test('signed out: nothing to send or refresh', () async {
      SharedPreferences.setMockInitialValues({});
      var calls = 0;
      final client = MockClient((_) async {
        calls++;
        return http.Response('"x"', 200);
      });

      expect(await SessionToken.current(client: client), isNull);
      expect(calls, 0);
    });

    test('a login token is stored with the time it was issued', () async {
      SharedPreferences.setMockInitialValues({});

      await SessionToken.save('fresh', now: issued);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(authTokenPrefKey), 'fresh');
      expect(prefs.getInt(authTokenIssuedAtPrefKey), issued.millisecondsSinceEpoch);
    });
  });
}
