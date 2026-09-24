// throw an Exception while looking for the Store Info Data


import '../../../../features/Products/ProductList/data/products_api_service.dart';
import 'productListModel.dart';

class ProductsRepositoryException implements Exception {}

class ProductsRepository {
  ProductsRepository({ProductsApiService? service})
      : _service = service ?? ProductsApiService();
  final ProductsApiService _service;

  Future<ProductListModel> requestProducts({
    required String query,
  }) async {
    try {
      return _service.getProductsData(query);
    } on Exception {
      throw ProductsRepositoryException();
    }
  }
}
