import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_vendor/core/helper/api_url_helpers.dart';
import 'package:multi_vendor/core/utils/money.dart';
import 'package:multi_vendor/features/Products/ProductList/data/productListModel.dart';
import 'package:multi_vendor/features/Products/ProductList/view/product_list_card_widget.dart';
import 'package:multi_vendor/l10n/app_localizations.dart';

void main() {
  setUp(() => Money.storeCurrency = 'AED');
  tearDown(() => Money.storeCurrency = null);

  MediaGalleryEntries entry(String file, {int position = 1, List<String> types = const [], bool disabled = false}) =>
      MediaGalleryEntries(file: file, position: position, types: types, disabled: disabled);

  group('List image (14zb93nvbjb item 5)', () {
    test("the original file of the thumbnail image, not the server's padded copy", () {
      final product = ProductItem(
          thumbnailUrl: 'https://multi.magento2.click/media/catalog/product/cache/75x75/a.jpg')
        ..mediaGalleryEntries = [
          entry('/a/b/main.jpg', position: 1, types: ['image']),
          entry('/c/d/thumb.jpg', position: 2, types: ['thumbnail', 'small_image']),
        ];
      expect(VendorAdminProductListCardWidget.listImageUrl(product),
          '$baseProductImageUrl/c/d/thumb.jpg');
    });

    test('without roles, the first enabled image by position', () {
      final product = ProductItem()
        ..mediaGalleryEntries = [
          entry('/x/hidden.jpg', position: 1, disabled: true),
          entry('/x/second.jpg', position: 3),
          entry('/x/first.jpg', position: 2),
        ];
      expect(VendorAdminProductListCardWidget.listImageUrl(product),
          '$baseProductImageUrl/x/first.jpg');
    });

    test('with no images, thumbnail_url as before', () {
      expect(VendorAdminProductListCardWidget.listImageUrl(ProductItem(thumbnailUrl: 'https://x/t.jpg')),
          'https://x/t.jpg');
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
}
