import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:multi_vendor/core/utils/product_url_key.dart';

void main() {
  group('New product URL key (14zb93nuzrw)', () {
    test('is readable: name and SKU words plus a short random tail', () {
      // Was 100 random characters, e.g. /en/k3f9x1…(100 chars).html.
      expect(productUrlKey('Test add product app', '2345'),
          matches(RegExp(r'^test-add-product-app-2345-[a-z0-9]{6}$')));
      expect(productUrlKey('QA Test Product', 'QA-0924'),
          matches(RegExp(r'^qa-test-product-qa-0924-[a-z0-9]{6}$')));
    });

    test('keeps the Latin part of Arabic names and SKUs', () {
      expect(productUrlKey('حقيبة يد', '7888-اسود'),
          matches(RegExp(r'^7888-[a-z0-9]{6}$')));
      expect(productUrlKey('حقيبة يد', 'حقيبة'),
          matches(RegExp(r'^product-[a-z0-9]{6}$')));
      expect(productUrlKey(null, null), matches(RegExp(r'^product-[a-z0-9]{6}$')));
    });

    test('stays short and differs between products with the same name', () {
      final long = productUrlKey('word ' * 40, 'SKU-1');
      expect(long.length, lessThanOrEqualTo(67));
      expect(long, isNot(contains('--')));
      expect(productUrlKey('Same', 'A', random: Random(1)),
          isNot(productUrlKey('Same', 'A', random: Random(2))));
    });
  });
}
