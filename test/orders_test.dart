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

    test('older pages are added until a short page', () {
      final full = addOrderPage(orders(1, 20),
          OrderListModel(items: orders(21, 20), totalCount: 20),
          pageNumber: 2, pageSize: 20);
      expect(full.orders.length, 40);
      expect(full.hasMore, isTrue);

      final last = addOrderPage(orders(1, 80),
          OrderListModel(items: orders(81, 10), totalCount: 10),
          pageNumber: 5, pageSize: 20);
      expect(last.orders.length, 90);
      expect(last.hasMore, isFalse);
    });

    test("a total_count that only counts the page does not stop the list", () {
      // What /V1/vendors/order sends for a seller with 90 orders.
      final first = addOrderPage(const [],
          OrderListModel(items: orders(1, 20), totalCount: 20),
          pageNumber: 1, pageSize: 20);
      expect(first.hasMore, isTrue);
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

  group('Order 3000000182 (TC90, 14zb93nvwph)', () {
    test('the shipping method comes with the order', () {
      expect(
          details.OrderModel.fromJson({'shipping_description': 'Flat Rate - Fixed'}).shippingDescription,
          'Flat Rate - Fixed');
      expect(details.OrderModel.fromJson({}).shippingDescription, isNull);
    });

    test('the item card shows row_total as Subtotal, and Row Total with tax less the discount', () {
      // The values the backend gives for the item: the card shows them as
      // the web admin does, 3,500 and 3,740.
      final item = details.Items.fromJson(
          {'row_total': 3500, 'tax_amount': 340, 'discount_amount': 100});

      expect(item.rowTotal, 3500);
      expect(item.rowTotalWithTax, 3740);
    });
  });

  group('A special price is shown as a discount (TC89, 14zb93nvw6m)', () {
    // Order 3000000181: test61 at a special price of 2,000 instead of 4,000.
    // The admin shows Discount Amount 2,000, Subtotal 4,000, Discount -2,000.
    Map<String, dynamic> item({
      num own = 4000,
      num sold = 2000,
      num qty = 1,
      num discount = 0,
      int? parent,
    }) =>
        {
          'original_price': own,
          'price': sold,
          'base_original_price': own,
          'base_price': sold,
          'qty_ordered': qty,
          'discount_amount': discount,
          'row_total': sold * qty,
          'tax_amount': sold * qty / 10,
          if (parent != null) 'parent_item_id': parent,
        };

    details.OrderModel order(List<Map<String, dynamic>> items,
            {num subtotal = 2000, num discount = 0}) =>
        details.OrderModel.fromJson({
          'base_subtotal': subtotal,
          'base_discount_amount': discount,
          'base_grand_total': 2200,
          'items': items,
        });

    test("the item's Discount Amount includes the drop from its own price", () {
      final sold = details.Items.fromJson(item());

      expect(sold.shownDiscount, 2000);
      // Row Total stays as sold: 2,000 plus 200 tax.
      expect(sold.rowTotalWithTax, 2200);
      expect(details.Items.fromJson(item(discount: 150)).shownDiscount, 2150);
      expect(details.Items.fromJson(item(qty: 3)).shownDiscount, 6000);
    });

    test('the totals show the subtotal at the own prices and the discount', () {
      final shown = order([item()]);

      expect(shown.shownBaseSubtotal, 4000);
      expect(shown.shownBaseDiscount, -2000);
      expect(shown.baseGrandTotal, 2200);
    });

    test('a cart discount on top adds to it', () {
      expect(order([item()], discount: -100).shownBaseDiscount, -2100);
    });

    test('without a special price nothing changes', () {
      final plain = order([item(own: 2000)]);

      expect(plain.shownBaseSubtotal, 2000);
      expect(plain.shownBaseDiscount, 0);
      expect(order([item(own: 2000)], discount: -50).shownBaseDiscount, -50);
      expect(details.Items.fromJson(item(own: 2000)).shownDiscount, 0);
    });

    test("a seller's order, which stores its discount positive, shows it negative (TC90)", () {
      // Order 3000000182: the seller's order says base_discount_amount 100.
      expect(order([item(own: 3500, sold: 3500)], subtotal: 3500, discount: 100).shownBaseDiscount, -100);
      expect(order([item(own: 3500, sold: 3500)], subtotal: 3500).shownBaseDiscount, 0);
    });

    test("a configurable's child row counts no discount of its own", () {
      final shown = order([
        item(own: 300, sold: 300),
        item(own: 250, sold: 0, parent: 1),
      ], subtotal: 300);

      expect(shown.shownBaseDiscount, 0);
      expect(shown.shownBaseSubtotal, 300);
      expect(details.Items.fromJson(item(own: 250, sold: 0, parent: 1)).shownDiscount, 0);
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

  testWidgets('the order number stays on one line in a narrow row',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          // A row as narrow as on the phone, where it broke as
          // "#30000001" / "48".
          child: SizedBox(
            width: 280,
            child: OrderItem(
              order: OrderModel(
                  entityId: 5,
                  incrementId: '3000000148',
                  status: 'pending',
                  createdAt: '2026-09-27 10:00:00',
                  grandTotal: 963653),
            ),
          ),
        ),
      ),
    ));

    final number = tester.renderObject<RenderBox>(find.text('#3000000148'));
    // One line of 16 px text is about 22 px tall; two lines would be twice that.
    expect(number.size.height, lessThan(30));
  });
}
