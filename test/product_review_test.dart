import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:multi_vendor/core/config/pref_keys.dart';
import 'package:multi_vendor/core/utils/product_review.dart';
import 'package:multi_vendor/features/Products/CreateEditProduct/data/create_edit_product_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    test('a quantity change alone applies at once (14zb93nvfqv)', () {
      expect(review(['stock_item']), isFalse);
      expect(review(['status', 'stock_item']), isFalse);
    });
  });

  group('What the server kept for the admin (14zb93nvfqv)', () {
    const oldName = 'إعادة تيست قايمة المنتجات + اضافة المنتجات';
    Map<String, dynamic> product({
      String name = oldName,
      dynamic price = 2000,
      dynamic weight = 0.5,
      String description = 'Old text',
      List<dynamic> categories = const ['3'],
      int imageCount = 1,
      String? newFrom,
    }) =>
        {
          'sku': '1514',
          'name': name,
          'price': price,
          'weight': weight,
          'status': 1,
          'custom_attributes': [
            {'attribute_code': 'description', 'value': description},
            {'attribute_code': 'category_ids', 'value': categories},
            if (newFrom != null) {'attribute_code': 'news_from_date', 'value': newFrom},
          ],
          'media_gallery_entries': List.generate(imageCount, (i) => {'id': 950 + i}),
        };

    test("QA's edit of 1514: the name and price wait, the quantity does not", () {
      // Sent "test name", 3000 and qty 800; the reply kept the old name and
      // 2000, and the admin grid listed "Product Name, Price" as waiting.
      final sent = product(name: 'test name', price: 3000)
        ..['extension_attributes'] = {'stock_item': {'qty': 800}};
      expect(
          changesAwaitingApproval(
              changedFields: ['name', 'price', 'stock_item'], sent: sent, reply: product()),
          ['name', 'price']);
    });

    test('nothing waits when the reply carries every change', () {
      final sent = product(name: 'test name', price: 3000, description: 'New text');
      final reply = product(name: 'test name', price: '3000.000000', description: 'New text');
      expect(
          changesAwaitingApproval(
              changedFields: ['name', 'price', 'description'], sent: sent, reply: reply),
          isEmpty);
    });

    test('a status or quantity change never waits', () {
      expect(
          changesAwaitingApproval(
              changedFields: ['status', 'stock_item'], sent: product(), reply: product()),
          isEmpty);
    });

    test('a custom attribute that came back unchanged waits', () {
      expect(
          changesAwaitingApproval(
              changedFields: ['description', 'weight'],
              sent: product(description: 'New text', weight: 0.9),
              reply: product(weight: '0.9000')),
          ['description']);
    });

    test('a new image or category waits until the reply has it', () {
      expect(
          changesAwaitingApproval(
              changedFields: ['media_gallery_entries', 'category_ids'],
              sent: product(imageCount: 2, categories: ['3', 5]),
              reply: product()),
          ['media_gallery_entries', 'category_ids']);
      expect(
          changesAwaitingApproval(
              changedFields: ['media_gallery_entries', 'category_ids'],
              sent: product(imageCount: 2, categories: ['3', 5]),
              reply: product(imageCount: 2, categories: ['5', '3'])),
          isEmpty);
    });

    test('a date the server stores with a midnight time is the same date', () {
      expect(
          changesAwaitingApproval(
              changedFields: ['news_from_date'],
              sent: product(newFrom: '2026-10-01'),
              reply: product(newFrom: '2026-10-01 00:00:00')),
          isEmpty);
    });
  });

  test("the save keeps the server's reply, the product as it now stands (14zb93nvfqv)",
      () async {
    SharedPreferences.setMockInitialValues({
      authTokenPrefKey: 'seller-token',
      authTokenIssuedAtPrefKey: DateTime.now().millisecondsSinceEpoch,
    });
    final client = MockClient((request) async => http.Response(
        jsonEncode({'id': 2413, 'sku': '1514', 'name': 'Old name', 'price': 2000, 'status': 1}),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'}));

    final saved = await CreateEditProductApiService(httpClient: client).postProductData(
        requestValueMap: {'product': {'sku': '1514', 'name': 'test name', 'price': 3000}},
        isUpdate: true);

    expect(saved.products?.single.name, 'Old name');
    expect(saved.products?.single.price, 2000);
  });
}
