// throw an Exception while looking for the Store Info Data



import 'package:multi_vendor/features/Products/ProductList/data/productListModel.dart';

import 'ProductAttributeSetList.dart';
import 'create_edit_product_api_service.dart';
import 'ProductAttributeModel.dart';

class CreateEditProductRepositoryException implements Exception {}

class CreateEditProductRepository {
  CreateEditProductRepository({CreateEditProductApiService? service})
      : _service = service ?? CreateEditProductApiService();
  final CreateEditProductApiService _service;

  Future<List<ProductAttributeModel>> requestProductsAttribute({
    required String query,
  }) async {
    try {
      return _service.getProductsAttributeData(query);
    } on Exception {
      throw CreateEditProductRepositoryException();
    }
  }

  Future<List<ProductAttributeSetList>> requestProductsAttributeSetList({
    required String query,
  }) async {
    try {
      return _service.getProductsAttributeSetListData(query);
    } on Exception {
      throw CreateEditProductRepositoryException();
    }
  }

  Future<ProductListModel> requestSaveProduct({
    required Map<String, dynamic> requestValueMap,
    required bool isUpdate,
  }) async {
    try {
      return _service.postProductData(
        requestValueMap: requestValueMap,
        isUpdate: isUpdate
      );
    } on Exception {
      throw CreateEditProductRepositoryException();
    }
  }

  Future<ProductItem> requestSingleProduct({
    required String productSku,
  }) async {
    try {
      return _service.getSingleProduct(
        productSku
      );
    } on Exception {
      throw CreateEditProductRepositoryException();
    }
  }

  Future<bool> requestDeleteProductMedia({
    required String sku,
    required MediaGalleryEntries mediaGalleryEntry,
  }) async {
    try {
      return _service.deleteProductMedia(sku,mediaGalleryEntry);
    } on Exception {
      throw CreateEditProductRepositoryException();
    }
  }

  Future<List<Map<String, dynamic>>> requestProductCategories() async {
    try {
      return _service.getProductCategories();
    } on Exception {
      throw CreateEditProductRepositoryException();
    }
  }
}
