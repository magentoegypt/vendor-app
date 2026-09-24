import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:multi_vendor/core/config/tools.dart';
import 'package:multi_vendor/core/utils/json_parser.dart';
import 'package:multi_vendor/features/Orders/OrderList/data/orderListModel.dart'
    as order_list;
import 'package:multi_vendor/features/Orders/SingleOrder/data/OrderModel.dart';
import 'package:multi_vendor/features/Products/CreateEditProduct/data/StockItemQunatityModel.dart';
import 'package:multi_vendor/features/Products/ProductList/data/productListModel.dart';
import 'package:multi_vendor/features/home/data/DashboarModel.dart';
import 'package:multi_vendor/features/home/data/UserModel.dart';

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

  group('Order details (86d4b15fw)', () {
    const body = '''
{
  "commission": 15.5, "entity_id": 17, "vendor_id": "7", "order_id": 33,
  "status": "processing", "increment_id": "000000017",
  "base_grand_total": 149.95, "grand_total": 149.95, "base_subtotal": 140.0,
  "base_shipping_amount": 9.95, "base_total_paid": 0.0, "base_total_due": 149.95,
  "total_qty_ordered": 2.0, "weight": 1.5,
  "created_at": "2026-09-13 12:47:22",
  "customer_name": "Test Customer", "customer_email": "customer@example.test",
  "customer_group": 1, "payment_method": "Cash On Delivery",
  "billing_address": {"firstname": "Test", "lastname": "Customer",
    "street": ["1 Main St", "Floor 2"], "postcode": "12345", "city": "Cairo",
    "telephone": "0100", "entity_id": 70, "parent_id": 33, "region_id": null},
  "shipping_address": [],
  "items": [
    {"item_id": 90, "name": "Web shirt", "sku": "web-shirt",
     "price": 70.0, "original_price": 74.975, "qty_ordered": 2.0,
     "row_total": 140.0, "row_total_incl_tax": 140.0, "tax_amount": 0.0,
     "tax_percent": 14.0, "discount_amount": 0.0, "item_options": [],
     "weee_tax_applied": "[]", "extension_attributes": {"status": "Ordered"}}
  ],
  "payment": {"method": "cashondelivery", "additional_information": [],
    "account_status": null, "cc_last4": "1234", "amount_ordered": 149.95},
  "can_cancel": true, "can_ship": 1
}''';

    test('parses decimal totals and quantities', () {
      final order = OrderModel.fromJson(decode(body));

      expect(order.incrementId, '000000017');
      expect(order.vendorId, 7);
      expect(order.baseGrandTotal, 149.95);
      expect(order.commission, 15.5);
      expect(order.totalQtyOrdered, 2);
      expect(order.customerName, 'Test Customer');
      expect(order.customerGroup, '1');
      expect(order.billingAddress?.street, ['1 Main St', 'Floor 2']);
      expect(order.shippingAddress, isNull);
      expect(order.items, hasLength(1));
      expect(order.items!.first.qtyOrdered, 2);
      expect(order.items!.first.originalPrice, 74.975);
      expect(order.payment?.additionalInformation, isEmpty);
      expect(order.canShip, isTrue);
    });

    test('order list and dashboard accept decimals', () {
      final list = order_list.OrderListModel.fromJson(decode(
          '{"items": [{"entity_id": 1, "grand_total": 100.0, "total_qty_ordered": 1.0,'
          ' "billing_address": {"street": null}}], "total_count": 1,'
          ' "search_criteria": {"page_size": 5}}'));
      expect(list.items!.single.grandTotal, 100);
      expect(list.searchCriteria?.pageSize, 5);

      final dashboard = DashboarModel.fromJson(decode(
          '{"credit_amount": 0, "lifetime_sales": "EGP1,250.00", "average_orders": 12.5,'
          ' "total_products": "12", "order_chart_data": [{"time": "Sep", '
          '"number_of_order": 3, "order_amount": 99.5}]}'));
      expect(dashboard.creditAmount, '0');
      expect(dashboard.totalProducts, 12);
      expect(dashboard.orderChartData!.single.orderAmount, 99.5);
    });

    test('vendor profile tolerates numeric ids sent as strings', () {
      final user = UserModel.fromJson(decode(
          '{"id": "4", "vendor_id": 12, "status": "1", "region_id": 0,'
          ' "street": "1 Main St", "postcode": 12345}'));
      expect(user.id, 4);
      expect(user.vendorId, '12');
      expect(user.postcode, '12345');
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
