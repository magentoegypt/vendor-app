import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_vendor/core/utils/money.dart';
import 'package:multi_vendor/features/Products/CreateEditProduct/view/widgets/pending_approval_notice.dart';
import 'package:multi_vendor/features/Products/ProductList/data/productListModel.dart';
import 'package:multi_vendor/features/Products/ProductList/view/product_list_card_widget.dart';
import 'package:multi_vendor/l10n/app_localizations.dart';

void main() {
  setUp(() => Money.storeCurrency = 'AED');
  tearDown(() => Money.storeCurrency = null);

  group('List image (14zb93nvbjb item 5)', () {
    test("the original file, not the server's 100 px padded copy", () {
      // test63's thumbnail_url as /V1/vendors/product sends it: a 100x100 copy
      // padded with white; the original, 1152x648, has no cache part.
      final product = ProductItem(
          thumbnailUrl: 'https://hub-market.magento2.click/media/catalog/product/cache/'
              'd2c3d712a0bbed73870d8655391daf81/u/n/untitled_7.png');
      expect(VendorAdminProductListCardWidget.listImageUrl(product),
          'https://hub-market.magento2.click/media/catalog/product/u/n/untitled_7.png');
    });

    test('other images (a placeholder) are shown as sent', () {
      const placeholder = 'https://hub-market.magento2.click/static/frontend/placeholder/thumbnail.jpg';
      expect(VendorAdminProductListCardWidget.listImageUrl(ProductItem(thumbnailUrl: placeholder)),
          placeholder);
      expect(VendorAdminProductListCardWidget.listImageUrl(ProductItem()), isNull);
    });
  });

  Future<void> card(WidgetTester tester, ProductItem product, {Locale locale = const Locale('en')}) =>
      tester.pumpWidget(MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(width: 360, child: VendorAdminProductListCardWidget(product: product)),
        ),
      ));

  group('Price and qty (14zb93nvbjb item 7)', () {
    testWidgets('a simple product shows its price and qty', (tester) async {
      await card(tester, ProductItem(name: 'test60', typeId: 'simple', price: 500, qty: 991));
      expect(find.text('AED 500.00'), findsOneWidget);
      expect(find.text('qty: 991'), findsOneWidget);
    });

    testWidgets('grouped and configurable products hide the 0 price and qty', (tester) async {
      for (final type in ['grouped', 'configurable', 'bundle']) {
        await card(tester, ProductItem(name: 'test $type', typeId: type, price: 0, qty: 0));
        expect(find.text('AED 0.00'), findsNothing, reason: type);
        expect(find.textContaining('qty:'), findsNothing, reason: type);
      }
    });

    testWidgets('a fixed-price bundle keeps its price', (tester) async {
      await card(tester, ProductItem(name: 'test bundle', typeId: 'bundle', price: 750, qty: 0));
      expect(find.text('AED 750.00'), findsOneWidget);
    });
  });

  group('Type badge (14zb93nvbjb item 6)', () {
    testWidgets('long type names stay on one line', (tester) async {
      await card(tester, ProductItem(name: 'test Downloadable', typeId: 'downloadable', price: 500, qty: 19));
      final label = tester.renderObject<RenderBox>(find.text('DOWNLOADABLE'));
      // One line of 12 px text; wrapped it was two.
      expect(label.size.height, lessThan(20));
    });

    testWidgets('every type is named in Arabic too', (tester) async {
      await card(tester, ProductItem(name: 'x', typeId: 'downloadable', price: 1), locale: const Locale('ar'));
      expect(find.text('قابل للتنزيل'), findsOneWidget);
      await card(tester, ProductItem(name: 'x', typeId: 'configurable'), locale: const Locale('ar'));
      expect(find.text('قابل للتكوين'), findsOneWidget);
    });
  });

  group('Waiting for approval (14zb93nvqy5)', () {
    ProductItem withApproval(String value) => ProductItem(
        name: 'Test 90',
        typeId: 'simple',
        price: 101,
        qty: 10,
        customAttributes: [CustomAttributes(attributeCode: 'approval', value: value)]);

    test('the approval value comes from the custom attributes', () {
      expect(withApproval('4').approval, '4');
      expect(withApproval('4').awaitsApproval, isTrue);
      expect(withApproval('1').awaitsApproval, isTrue);
      expect(withApproval('2').awaitsApproval, isFalse);
      expect(ProductItem().approval, isNull);
    });

    testWidgets('a card whose product or latest edit waits for the admin says so', (tester) async {
      await card(tester, withApproval('4'));
      expect(find.text('Waiting for approval'), findsOneWidget);
      await card(tester, withApproval('1'));
      expect(find.text('Waiting for approval'), findsOneWidget);
      await card(tester, withApproval('2'));
      expect(find.text('Waiting for approval'), findsNothing);
      await card(tester, withApproval('4'), locale: const Locale('ar'));
      expect(find.text('بانتظار الموافقة'), findsOneWidget);
    });

    testWidgets('the form says why it shows the product as it was', (tester) async {
      Future<void> notice(String? approval) => tester.pumpWidget(MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: PendingApprovalNotice(approval: approval)),
          ));

      await notice('4');
      expect(find.textContaining('Your latest changes are waiting for admin approval'), findsOneWidget);
      await notice('1');
      expect(find.textContaining('waiting for admin approval before it appears'), findsOneWidget);
      for (final other in ['2', '3', null]) {
        await notice(other);
        expect(find.byType(Text), findsNothing, reason: '$other');
      }
    });
  });
}
