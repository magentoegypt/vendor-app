import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:multi_vendor/core/config/app_constants.dart';
import 'package:multi_vendor/core/config/pref_keys.dart';
import 'package:multi_vendor/core/helper/store_time.dart';
import 'package:multi_vendor/features/Orders/OrderList/data/orderListModel.dart';
import 'package:multi_vendor/features/Orders/OrderList/view/order_item.dart';
import 'package:multi_vendor/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(() => StoreTime.timezone = null);

  // Order 3000000177: 23:25:58 UTC on the 27th is 02:25:58 on the 28th in
  // Riyadh (UTC+3), the store's timezone. The web panel shows 28 Sep.
  const late177 = '2026-09-27 23:25:58';

  group('Order dates in store time (14zb93nvau4)', () {
    test('created_at is read as UTC and shown in the store timezone', () {
      StoreTime.timezone = 'Asia/Riyadh';
      final placed = StoreTime.of(late177)!;
      expect(
          [placed.year, placed.month, placed.day, placed.hour, placed.minute, placed.second],
          [2026, 9, 28, 2, 25, 58]);
    });

    test('a daytime order keeps its date', () {
      StoreTime.timezone = 'Asia/Riyadh';
      final placed = StoreTime.of('2026-09-28 10:02:33')!;
      expect([placed.day, placed.hour, placed.minute], [28, 13, 2]);
    });

    test("until the store timezone is known, the phone's is used", () {
      expect(StoreTime.of(late177), DateTime.utc(2026, 9, 27, 23, 25, 58).toLocal());
    });

    test("a timezone name the database doesn't know falls back to the phone", () {
      StoreTime.timezone = 'Nowhere/Unknown';
      expect(StoreTime.of(late177), DateTime.utc(2026, 9, 27, 23, 25, 58).toLocal());
    });

    test('empty or unreadable dates give nothing', () {
      StoreTime.timezone = 'Asia/Riyadh';
      expect(StoreTime.of(null), isNull);
      expect(StoreTime.of(''), isNull);
      expect(StoreTime.of('not a date'), isNull);
    });

    test("load takes this store view's timezone and saves it", () async {
      SharedPreferences.setMockInitialValues({});
      final previous = selectedLanguage;
      addTearDown(() => selectedLanguage = previous);
      selectedLanguage = 'ar';
      late http.Request sent;
      final client = MockClient((request) async {
        sent = request;
        return http.Response(
            jsonEncode([
              {'code': 'en', 'timezone': 'Asia/Riyadh'},
              {'code': 'ar', 'timezone': 'Asia/Dubai'},
            ]),
            200);
      });
      var changes = 0;

      await StoreTime.load(client: client, onChanged: () => changes++);

      expect(sent.url.path, '/rest/ar/V1/store/storeConfigs');
      expect(StoreTime.timezone, 'Asia/Dubai');
      expect(changes, 1);
      expect((await SharedPreferences.getInstance()).getString(storeTimezonePrefKey),
          'Asia/Dubai');
    });

    test('offline, the timezone saved last time is used', () async {
      SharedPreferences.setMockInitialValues({storeTimezonePrefKey: 'Asia/Riyadh'});
      final client = MockClient((_) async => throw Exception('offline'));

      await StoreTime.load(client: client);

      expect(StoreTime.timezone, 'Asia/Riyadh');
    });
  });

  testWidgets('the order list and Latest Sales show the store date', (tester) async {
    StoreTime.timezone = 'Asia/Riyadh';
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: OrderItem(
          order: OrderModel(
              entityId: 5,
              incrementId: '3000000177',
              status: 'pending',
              createdAt: late177,
              grandTotal: 800),
        ),
      ),
    ));

    expect(find.text('09/28/2026'), findsOneWidget);
    expect(find.text('09/27/2026'), findsNothing);
  });
}
