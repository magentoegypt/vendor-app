import 'package:flutter_test/flutter_test.dart';
import 'package:multi_vendor/core/utils/category_selection.dart';

void main() {
  group('Product categories (14zb93nv5v7)', () {
    test('unticking a saved category removes it', () {
      // The product came with category 12; the tree's ids are ints.
      final ids = ['12', '40'];

      applyCategoryChecks(ids, [
        {'id': 12, 'checked': 0},
      ]);

      expect(ids, ['40']);
    });

    test('ticking adds a category once', () {
      final ids = <String>[];

      applyCategoryChecks(ids, [
        {'id': 7, 'checked': 2},
      ]);
      applyCategoryChecks(ids, [
        {'id': 7, 'checked': 2},
      ]);

      expect(ids, ['7']);
    });

    test('ticking and unticking again leaves the product as it was', () {
      final ids = ['3'];

      applyCategoryChecks(ids, [
        {'id': 9, 'checked': 2},
      ]);
      applyCategoryChecks(ids, [
        {'id': 9, 'checked': 0},
      ]);

      expect(ids, ['3']);
    });
  });
}
