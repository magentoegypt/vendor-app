import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:multi_vendor/features/Products/CreateEditProduct/data/StockItemQunatityModel.dart';
import 'package:multi_vendor/features/Products/ProductList/data/productListModel.dart';
import '../../../../core/config/app_constants.dart';
import '../../../../core/config/app_exceptions.dart';
import '../../../../core/config/logger.dart';
import '../../../../core/config/pref_keys.dart';
import '../../../../core/helper/api_response_helper.dart';
import '../../../../core/helper/api_url_helpers.dart';
import '../../../../core/helper/shared_preferences_helpers.dart';
import '../../../../core/values/string_values.dart';
import 'ProductAttributeModel.dart';
import 'ProductAttributeSetList.dart';



class CreateEditProductApiService {
  final http.Client _httpClient;
  final SharedPreferencesHelpers _sharedPrefKeys = SharedPreferencesHelpers();

  CreateEditProductApiService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<List<ProductAttributeModel>> getProductsAttributeData(String query) async {
    final responseBody = await _getProductsAttributeData(query);

    try {
      //
      List<ProductAttributeModel> list = [];
      responseBody.forEach((v) {
        list.add(ProductAttributeModel.fromJson(v));
      });
      return list;
      //
    } catch (exception, stackTrace) {
      //
      printLog(
        classFileName: runtimeType.toString(),
        logType: LoggerType.e,
        message: '$exception\n$stackTrace',
      );
      //await Sentry.captureException(exception, stackTrace: stackTrace);
      throw JsonDeserializationException(['$exception']);
    }
  }

  /// get Data Functions
  Future<dynamic> _getProductsAttributeData(String query) async {
    try {
      var token = await _sharedPrefKeys.getStringData(key: authTokenPrefKey);
      final response = await _httpClient.get(
        Uri.parse(vendorsProductAttributeApi+query),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization":"Bearer ${token ?? ""}"
        },
      );
      return apiResponseHelper(
        response: response,
        className: runtimeType.toString(),
        apiUrl: vendorsProductAttributeApi+query,
        requestValue: '',
        token: token ?? '',
      );
    } on SocketException {
      throw HttpException(StringValues.no_internet);
    } catch (exception) {
      //await Sentry.captureException(exception, stackTrace: stackTrace);
      throw HttpException('Error Communicating with Server');
    }
  }

  Future<List<ProductAttributeSetList>> getProductsAttributeSetListData(String query) async {
    final responseBody = await _getProductsAttributeSetListData(query);

    try {
      //
      List<ProductAttributeSetList> list = [];
      var items = responseBody["items"];
      items.forEach((v) {
        list.add(ProductAttributeSetList.fromJson(v));
      });
      return list;
      //
    } catch (exception, stackTrace) {
      //
      printLog(
        classFileName: runtimeType.toString(),
        logType: LoggerType.e,
        message: '$exception\n$stackTrace',
      );
      //await Sentry.captureException(exception, stackTrace: stackTrace);
      throw JsonDeserializationException(['$exception']);
    }
  }

  /// get Data Functions
  Future<dynamic> _getProductsAttributeSetListData(String query) async {
    try {
      var token = await _sharedPrefKeys.getStringData(key: authTokenPrefKey);
      final response = await _httpClient.get(
        Uri.parse(vendorsProductAttributeSetListApi+query),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization":"Bearer ${token ?? ""}"
        },
      );
      return apiResponseHelper(
        response: response,
        className: runtimeType.toString(),
        apiUrl: vendorsProductAttributeSetListApi+query,
        requestValue: '',
        token: token ?? '',
      );
    } on SocketException {
      throw HttpException(StringValues.no_internet);
    } catch (exception) {
      //await Sentry.captureException(exception, stackTrace: stackTrace);
      throw HttpException('Error Communicating with Server');
    }
  }

  Future<ProductListModel> postProductData({
    required Map<String, dynamic> requestValueMap,
    required bool isUpdate,
  }) async {
    final responseBody = await _postProductData(
      requestValueMap: requestValueMap,
        isUpdate:isUpdate
    );
    try {
      return ProductListModel.fromJson(responseBody);
    } catch (exception, stackTrace) {
      //
      printLog(
        classFileName: 'SaveProductDataApiService',
        logType: LoggerType.e,
        message: '$exception\n$stackTrace',
      );
      //await Sentry.captureException(exception, stackTrace: stackTrace);
      throw JsonDeserializationException(['$exception']);
    }
  }

  /// get Data Functions
  Future<dynamic> _postProductData({
    required Map<String, dynamic> requestValueMap,
    required bool isUpdate,
  }) async {
    try {
      var token = await _sharedPrefKeys.getStringData(key: authTokenPrefKey);
      print(token);
      http.Response response;
      if(isUpdate){
        response = await _httpClient.put(
          Uri.parse(vendorsSaveProductsApi),
          headers: <String, String>{
            'Content-Type': 'application/json',
            "Authorization":"Bearer ${token ?? ""}"
          },
          body: json.encode(requestValueMap),
        );
      }else{
        response = await _httpClient.post(
          Uri.parse(vendorsSaveProductsApi),
          headers: <String, String>{
            'Content-Type': 'application/json',
            "Authorization":"Bearer ${token ?? ""}"
          },
          body: json.encode(requestValueMap),
        );
      }
      return apiResponseHelper(
        response: response,
        className: 'SaveProductDataApiService',
        apiUrl: vendorsSaveProductsApi,
        requestValue: '$requestValueMap',
        token: token ?? '',
      );
    } on SocketException {
      throw HttpException(StringValues.no_internet);
    } catch (exception, stackTrace) {
      throw HttpException('Error Communicating with Server');
    }
  }

  Future<ProductItem> getSingleProduct(String productSku) async {
    final response = await _getSingleProductQuantity(productSku);
    final responseBody = await _getSingleProduct(productSku);
    try {
      //
      StockItemQunatityModel stockItemQunatityModel = StockItemQunatityModel.fromJson(response);
      ProductItem productItem = ProductItem.fromJson(responseBody);
      productItem.stockItemQunatityModel = stockItemQunatityModel;
      return productItem;
      //
    } catch (exception, stackTrace) {
      //
      printLog(
        classFileName: runtimeType.toString(),
        logType: LoggerType.e,
        message: '$exception\n$stackTrace',
      );
      //await Sentry.captureException(exception, stackTrace: stackTrace);
      throw JsonDeserializationException(['$exception']);
    }
  }

  /// get Data Functions
  Future<dynamic> _getSingleProduct(String productSku) async {
    try {
      var token = await _sharedPrefKeys.getStringData(key: authTokenPrefKey);
      final response = await _httpClient.get(
        Uri.parse(vendorsSingleProductsApi+productSku.replaceAll(" ","%20")),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization":"Bearer ${token ?? ""}"
        },
      );
      return apiResponseHelper(
        response: response,
        className: runtimeType.toString(),
        apiUrl: vendorsSingleProductsApi+productSku.replaceAll(" ","%20"),
        requestValue: '',
        token: token ?? '',
      );
    } on SocketException {
      throw HttpException(StringValues.no_internet);
    } catch (exception) {
      //await Sentry.captureException(exception, stackTrace: stackTrace);
      throw HttpException('Error Communicating with Server');
    }
  }

  Future<dynamic> _getSingleProductQuantity(String productSku) async {
    try {
      var token = await _sharedPrefKeys.getStringData(key: authTokenPrefKey);
      final response = await _httpClient.get(
        Uri.parse(vendorsSingleProductQuantityApi+productSku.replaceAll(" ","%20")),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization":"Bearer ${AdminKey ?? ""}"
        },
      );
      return apiResponseHelper(
        response: response,
        className: runtimeType.toString(),
        apiUrl: vendorsSingleProductQuantityApi+productSku.replaceAll(" ","%20"),
        requestValue: '',
        token: token ?? '',
      );
    } on SocketException {
      throw HttpException(StringValues.no_internet);
    } catch (exception) {
      //await Sentry.captureException(exception, stackTrace: stackTrace);
      throw HttpException('Error Communicating with Server');
    }
  }

  Future<List<Map<String, dynamic>>> getProductCategories() async {
    final responseBody = await _getProductCategories();
    try {
      return [responseBody];
    } catch (exception, stackTrace) {
      //
      printLog(
        classFileName: runtimeType.toString(),
        logType: LoggerType.e,
        message: '$exception\n$stackTrace',
      );
      //await Sentry.captureException(exception, stackTrace: stackTrace);
      throw JsonDeserializationException(['$exception']);
    }
  }

  Future<dynamic> _getProductCategories() async {
    try {
      var token = await _sharedPrefKeys.getStringData(key: authTokenPrefKey);
      final response = await _httpClient.get(
        Uri.parse(vendorsProductCategoriesApi),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization":"Bearer ${AdminKey ?? ""}"
        },
      );
      return apiResponseHelper(
        response: response,
        className: runtimeType.toString(),
        apiUrl: vendorsProductCategoriesApi,
        requestValue: '',
        token: token ?? '',
      );
    } on SocketException {
      throw HttpException(StringValues.no_internet);
    } catch (exception) {
      //await Sentry.captureException(exception, stackTrace: stackTrace);
      throw HttpException('Error Communicating with Server');
    }
  }

  Future<bool> deleteProductMedia(String sku,MediaGalleryEntries mediaGalleryEntry) async {
    final responseBody = await _deleteProductMedia(sku,mediaGalleryEntry);
    try {
      //
      return true;
      //
    } catch (exception, stackTrace) {
      //
      printLog(
        classFileName: runtimeType.toString(),
        logType: LoggerType.e,
        message: '$exception\n$stackTrace',
      );
      //await Sentry.captureException(exception, stackTrace: stackTrace);
      throw JsonDeserializationException(['$exception']);
    }
  }

  /// get Data Functions
  Future<dynamic> _deleteProductMedia(String sku,MediaGalleryEntries mediaGalleryEntry) async {
    try {

      var token = await _sharedPrefKeys.getStringData(key: authTokenPrefKey);
      print(token);
      print(mediaGalleryEntry.toJson());
      if ((mediaGalleryEntry.types?.length ?? 0)>0){
        mediaGalleryEntry.types = [];
        mediaGalleryEntry.toJson();
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data["entry"] = mediaGalleryEntry;
        final response =  await _httpClient.put(
          Uri.parse("$vendorsProductDeleteMediaApi${sku.replaceAll(" ","%20")}/media/${mediaGalleryEntry.id}"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            "Authorization":"Bearer ${token ?? ""}"
          },
          body: json.encode(data),
        );
        print(json.decode(response.body));
      }
      final response = await _httpClient.delete(
        Uri.parse("$vendorsProductDeleteMediaApi${sku.replaceAll(" ","%20")}/media/${mediaGalleryEntry.id}"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization":"Bearer ${token ?? ""}"
        },
      );
      return apiResponseHelper(
        response: response,
        className: runtimeType.toString(),
        apiUrl: "$vendorsProductDeleteMediaApi${sku.replaceAll(" ","%20")}/media/${mediaGalleryEntry.id}",
        requestValue: '',
        token: token ?? '',
      );
    } on SocketException {
      throw HttpException(StringValues.no_internet);
    } catch (exception) {
      //await Sentry.captureException(exception, stackTrace: stackTrace);
      throw HttpException('Error Communicating with Server');
    }
  }
}
