import 'json_parser.dart';

/// Changes the backend applies at once on an approved (live) product, with no
/// review: the status (enable or disable) and the stock. QA's second round on
/// TC68 saw the quantity change straight away while the name and price waited
/// for the admin.
const appliedAtOnce = {'status', 'stock_item'};

/// Whether saving an edit sends a product to the admin for review, as far as
/// the app can tell before the server answers.
///
/// On an approved (live) product, the backend puts a change other than
/// [appliedAtOnce] in review as Pending Update, which takes the product off
/// the store until the admin approves it (backend, 2026-09-29). The app lists
/// the images and categories on every save, so they count only when they
/// really changed: an image added or removed, or a category ticked or
/// unticked.
bool editGoesToReview({
  required bool live,
  required Iterable<String> changedFields,
  required List<dynamic> images,
  required int savedImageCount,
  required Iterable<dynamic> categoryIds,
  required Iterable<dynamic> savedCategoryIds,
}) {
  if (!live) return false;
  final otherFields = changedFields.any((field) => !appliedAtOnce.contains(field));
  return otherFields ||
      imagesChanged(images: images, savedImageCount: savedImageCount) ||
      categoriesChanged(categoryIds: categoryIds, savedCategoryIds: savedCategoryIds);
}

/// Whether the gallery sent differs from the saved one: a new image carries
/// its file as `content`, and a removed one leaves the list shorter.
bool imagesChanged({required List<dynamic> images, required int savedImageCount}) =>
    images.length != savedImageCount ||
    images.any((image) => image is Map && image.containsKey('content'));

/// Whether the categories sent differ from the saved ones.
bool categoriesChanged({
  required Iterable<dynamic> categoryIds,
  required Iterable<dynamic> savedCategoryIds,
}) {
  final ids = categoryIds.map((id) => '$id').toSet();
  final savedIds = savedCategoryIds.map((id) => '$id').toSet();
  return ids.length != savedIds.length || !ids.containsAll(savedIds);
}

/// The changes the server kept for the admin rather than applied.
///
/// Saving an edit returns the product as it now stands, and a change waiting
/// for approval keeps its old value there: QA's edit of SKU 1514 sent the name
/// "test name" and the price 3000, and the product kept its old name and 2000
/// until an admin approved. So a changed field whose value came back
/// different is waiting. [changedFields] are the attribute codes the edit
/// changed, with `media_gallery_entries` and `category_ids` only when the
/// images or categories really changed. [appliedAtOnce] changes never wait,
/// and the reply leaves the stock out anyway.
List<String> changesAwaitingApproval({
  required Iterable<String> changedFields,
  required Map<String, dynamic> sent,
  required Map<String, dynamic> reply,
}) {
  final waiting = <String>[];
  for (final field in changedFields) {
    if (appliedAtOnce.contains(field) || field == 'sku' || waiting.contains(field)) continue;
    final same = field == 'media_gallery_entries'
        ? _list(sent[field]).length == _list(reply[field]).length
        : _sameValue(_value(sent, field), _value(reply, field));
    if (!same) waiting.add(field);
  }
  return waiting;
}

List<dynamic> _list(dynamic value) => value is List ? value : const [];

/// A product field by attribute code: at the top level (name, price, weight,
/// status, visibility) or among the custom attributes.
dynamic _value(Map<String, dynamic> product, String code) {
  if (product.containsKey(code)) return product[code];
  for (final attribute in _list(product['custom_attributes'])) {
    if (attribute is Map && attribute['attribute_code'] == code) return attribute['value'];
  }
  return null;
}

bool _sameValue(dynamic a, dynamic b) {
  if (a is List || b is List) {
    final left = _list(a).map((item) => '$item').toSet();
    final right = _list(b).map((item) => '$item').toSet();
    return left.length == right.length && left.containsAll(right);
  }
  final left = _text(a);
  final right = _text(b);
  if (left == right) return true;
  final leftNumber = JsonParser.toNum(left);
  final rightNumber = JsonParser.toNum(right);
  return leftNumber != null && rightNumber != null && leftNumber == rightNumber;
}

/// Text as the server stores it: trimmed, and a date without the midnight
/// time Magento adds to it.
String _text(dynamic value) {
  final text = value?.toString().trim() ?? '';
  return text.endsWith(' 00:00:00') ? text.substring(0, text.length - 9) : text;
}
