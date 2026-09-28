import 'orderListModel.dart';

/// Adds page [pageNumber] of the vendor's orders (newest first) to [shown],
/// and says whether an older page may follow.
///
/// A page that is short, or adds nothing new, is the last one. Orders already
/// shown are skipped, so a server that ignores the page number cannot fill
/// the list with repeats or keep it loading forever.
///
/// total_count is not used: /V1/vendors/order reports the page's own count
/// there (20 for a seller with 90 orders), which stopped the list at 20.
({List<OrderModel> orders, bool hasMore}) addOrderPage(
  List<OrderModel> shown,
  OrderListModel page, {
  required int pageNumber,
  required int pageSize,
}) {
  final items = page.items ?? const <OrderModel>[];
  final List<OrderModel> orders;
  var added = items.length;
  if (pageNumber == 1) {
    orders = List.of(items);
  } else {
    final seen = shown.map((order) => order.entityId).toSet();
    final fresh = items.where((order) => !seen.contains(order.entityId)).toList();
    added = fresh.length;
    orders = [...shown, ...fresh];
  }
  final hasMore = items.length == pageSize && added > 0;
  return (orders: orders, hasMore: hasMore);
}
