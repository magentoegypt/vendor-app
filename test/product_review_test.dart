import 'package:flutter_test/flutter_test.dart';
import 'package:multi_vendor/core/utils/product_review.dart';

void main() {
  // SKU 2345 as loaded: approved, two images, no categories.
  final images = [
    {'id': 910, 'file': '/2/f/2fa28d9318db640ad128aa11d3d3d697.jpg'},
    {'id': 911, 'file': '/5/e/5e223cf6e999730dc039afd30674df79.jpg'},
  ];

  bool review(Iterable<String> changed,
          {bool live = true,
          List<dynamic>? media,
          List<String> categories = const [],
          List<String> savedCategories = const []}) =>
      editGoesToReview(
        live: live,
        changedFields: changed,
        images: media ?? images,
        savedImageCount: images.length,
        categoryIds: categories,
        savedCategoryIds: savedCategories,
      );

  group('Which saves wait for the admin (14zb93nv5v7)', () {
    test('disabling or enabling a live product applies at once', () {
      expect(review(['status']), isFalse);
    });

    test("QA's edit of a live product goes to review", () {
      expect(review(['name', 'price', 'stock_item', 'weight']), isTrue);
      expect(review(['status', 'price']), isTrue);
    });

    test('a new or removed image is a real change', () {
      expect(review(['status'], media: [...images, {'content': {'name': 'new.jpg'}}]), isTrue);
      expect(review(['status'], media: [images.first]), isTrue);
    });

    test('ticking or unticking a category is a real change', () {
      expect(review(['status'], categories: ['5']), isTrue);
      expect(review(['status'], savedCategories: ['5']), isTrue);
      expect(review(['status'], categories: ['5', '7'], savedCategories: ['7', '5']), isFalse);
    });

    test('a product that is not live yet is never "sent for review" again', () {
      expect(review(['name'], live: false), isFalse);
    });
  });
}
