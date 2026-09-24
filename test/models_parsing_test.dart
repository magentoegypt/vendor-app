import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:multi_vendor/core/config/tools.dart';
import 'package:multi_vendor/core/utils/json_parser.dart';
import 'package:multi_vendor/features/Products/CreateEditProduct/data/StockItemQunatityModel.dart';
import 'package:multi_vendor/features/Products/ProductList/data/productListModel.dart';

/// Decodes like the API layer does, so values keep their real JSON types
/// (PHP's json_encode writes Magento decimals as floats such as 10.0).
Map<String, dynamic> decode(String body) => json.decode(body);

void main() {
  group('JsonParser', () {
    test('reads ints from floats and strings', () {
      expect(JsonParser.toInt(2.0), 2);
      expect(JsonParser.toInt('5'), 5);
      expect(JsonParser.toInt('5.0000'), 5);
      expect(JsonParser.toInt(null), isNull);
      expect(JsonParser.toInt('abc'), isNull);
    });

    test('reads numbers, strings and bools leniently', () {
      expect(JsonParser.toNum('99.99'), 99.99);
      expect(JsonParser.toStr(12), '12');
      expect(JsonParser.toStr(<dynamic>[]), isNull);
      expect(JsonParser.toBool('1'), isTrue);
      expect(JsonParser.toBool(0), isFalse);
    });

    test('toObject ignores the [] PHP sends for an empty object', () {
      expect(JsonParser.toObject(<dynamic>[], (json) => json), isNull);
    });

    test('toList skips rows that fail to parse', () {
      final rows = JsonParser.toList<int>(
        [
          {'v': 1},
          'not an object',
          {'v': 'boom'},
          {'v': 3},
        ],
        (json) => json['v'] as int,
      );
      expect(rows, [1, 3]);
    });
  });

  group('Products list (86d4b147y)', () {
    const body = '''
{
  "items": [
    {
      "id": 101, "sku": "web-shirt", "name": "Web shirt",
      "attribute_set_id": 4, "price": 99.99, "status": 1, "visibility": 4,
      "type_id": "simple", "weight": 1.0, "qty": 10.0,
      "media_gallery_entries": [
        {"id": 7, "media_type": "image", "label": null, "position": 1,
         "disabled": false, "types": ["image", "thumbnail"], "file": "/w/s.jpg"},
        {"id": 8, "media_type": "image", "position": 2, "disabled": false,
         "types": null, "file": "/w/t.jpg"}
      ],
      "custom_attributes": [{"attribute_code": "category_ids", "value": ["3"]}],
      "thumbnail_url": "https://example.test/t.jpg"
    },
    {"id": "102", "sku": "app-cup", "name": "App cup", "price": 50,
     "weight": null, "qty": 3},
    "garbage-row"
  ],
  "total_count": 2
}''';

    test('parses web-created products with decimal qty and weight', () {
      final model = ProductListModel.fromJson(decode(body));

      expect(model.totalCount, 2);
      expect(model.products, hasLength(2));
      final web = model.products!.first;
      expect(web.qty, 10);
      expect(web.weight, 1);
      expect(web.price, 99.99);
      expect(web.mediaGalleryEntries, hasLength(2));
      expect(web.mediaGalleryEntries![1].types, isNull);
      expect(model.products![1].id, 102);
    });

    test('stock item qty is read as a decimal', () {
      final stock = StockItemQunatityModel.fromJson(
          decode('{"item_id": 5, "qty": 12.5, "is_in_stock": true, "min_qty": 0.0}'));
      expect(stock.qty, 12.5);
      expect(stock.isInStock, isTrue);
    });
  });

  group('Display formatting', () {
    test('prices always show two decimals', () {
      expect(Tools.formatPrice(100), '100.00');
      expect(Tools.formatPrice(149.95), '149.95');
      expect(Tools.formatPrice('12.5000'), '12.50');
    });

    test('quantities drop trailing zeros', () {
      expect(Tools.formatQty(2.0), '2');
      expect(Tools.formatQty(2.5), '2.5');
      expect(Tools.formatQty(14.0), '14');
    });
  });
}
