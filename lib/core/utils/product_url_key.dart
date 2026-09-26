import 'dart:math';

/// The storefront URL key for a new product: readable words from the name and
/// SKU plus a short random tail, because Magento refuses a key another product
/// already uses. "Test add product app" / "2345" gives
/// "test-add-product-app-2345-k3f9x1". Magento keeps only Latin letters and
/// digits, so a name and SKU with neither (Arabic) fall back to "product-…".
String productUrlKey(String? name, String? sku, {Random? random}) {
  var words = '${name ?? ''} ${sku ?? ''}'
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  if (words.length > 60) {
    words = words.substring(0, 60).replaceAll(RegExp(r'-+$'), '');
  }
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final rnd = random ?? Random();
  final tail = List.generate(6, (_) => chars[rnd.nextInt(chars.length)]).join();
  return '${words.isEmpty ? 'product' : words}-$tail';
}
