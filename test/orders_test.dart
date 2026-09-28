import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:multi_vendor/core/config/app_constants.dart';
import 'package:multi_vendor/core/helper/country_names.dart';
import 'package:multi_vendor/features/Orders/OrderList/data/orderListModel.dart';
import 'package:multi_vendor/features/Orders/OrderList/data/order_pages.dart';
import 'package:multi_vendor/features/Orders/OrderList/view/order_item.dart';
import 'package:multi_vendor/features/Orders/SingleOrder/data/OrderModel.dart'
    as details;
import 'package:multi_vendor/l10n/app_localizations.dart';

List<OrderModel> orders(int from, int count) =>
    List.generate(count, (i) => OrderModel(entityId: from + i));

void main() {
  group('Orders list pages (14zb93nv64v item 1)', () {
    test('the first page replaces the list', () {
      final page = addOrderPage(orders(900, 3),
          OrderListModel(items: orders(1, 20), totalCount: 90),
          pageNumber: 1, pageSize: 20);
      expect(page.orders.map((o) => o.entityId), orders(1, 20).map((o) => o.entityId));
      expect(page.hasMore, isTrue);
    });

    test('older pages are added until the total is reached', () {
      var shown = orders(1, 80);
      final last = addOrderPage(shown,
          OrderListModel(items: orders(81, 10), totalCount: 90),
          pageNumber: 5, pageSize: 20);
      expect(last.orders.length, 90);
      expect(last.hasMore, isFalse);
    });

    test('a server that ignores the page number cannot loop or repeat', () {
      final again = addOrderPage(orders(1, 20),
          OrderListModel(items: orders(1, 20), totalCount: 90),
          pageNumber: 2, pageSize: 20);
      expect(again.orders.length, 20);
      expect(again.hasMore, isFalse);
    });
  });

  group('Order details (14zb93nv64v items 3-4)', () {
    test('Row Total is the subtotal plus tax, less the discount', () {
      // Order 3000000056: Subtotal 500, Tax 50, Row Total 550 on the web panel.
      expect(details.Items(rowTotal: 500, taxAmount: 50, discountAmount: 0).rowTotalWithTax, 550);
      expect(details.Items(rowTotal: 800, taxAmount: 80).rowTotalWithTax, 880);
      expect(details.Items(rowTotal: 500, taxAmount: 45, discountAmount: 50).rowTotalWithTax, 495);
    });
  });

  group('Country names (14zb93nv64v item 5)', () {
    test('an address country code becomes the name in the app language', () async {
      final previous = selectedLanguage;
      addTearDown(() => selectedLanguage = previous);
      selectedLanguage = 'ar';
      final client = MockClient((request) async {
        expect(request.url.path, '/rest/ar/V1/directory/countries');
        return http.Response(
            '[{"id":"EG","full_name_locale":"مصر","full_name_english":"Egypt"}]', 200,
            headers: {'content-type': 'application/json; charset=utf-8'});
      });

      await CountryNames.load(client: client);

      expect(CountryNames.of('EG'), 'مصر');
      expect(CountryNames.of('AE'), isNull);
      expect(CountryNames.of(null), isNull);
    });
  });

  testWidgets('the list shows the order number, not the internal id (item 2)',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: OrderItem(
          order: OrderModel(
              entityId: 5,
              orderId: 137,
              incrementId: '3000000044',
              status: 'pending',
              createdAt: '2026-09-15 10:00:00',
              grandTotal: 550),
        ),
      ),
    ));

    expect(find.text('#3000000044'), findsOneWidget);
    expect(find.text('#137'), findsNothing);
  });
}
