// throw an Exception while looking for the Store Info Data



import 'OrderModel.dart';
import 'single_order_api_service.dart';

class SingleOrderRepositoryException implements Exception {}

class SingleOrderRepository {
  SingleOrderRepository({SingleOrderApiService? service})
      : _service = service ?? SingleOrderApiService();
  final SingleOrderApiService _service;

  Future<OrderModel> requestSingleOrder({
    required String orderId,
  }) async {
    try {
      return _service.getSingleOrderData(orderId: orderId);
    } on Exception {
      throw SingleOrderRepositoryException();
    }
  }
}
