// throw an Exception while looking for the Store Info Data



import 'orderListModel.dart';
import 'orders_api_service.dart';

class OrdersRepositoryException implements Exception {}

class OrdersRepository {
  OrdersRepository({OrdersApiService? service})
      : _service = service ?? OrdersApiService();
  final OrdersApiService _service;

  Future<OrderListModel> requestOrderList({
    required String query,
  }) async {
    try {
      return _service.getOrdersData(query: query);
    } on Exception {
      throw OrdersRepositoryException();
    }
  }
}
