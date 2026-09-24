import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/config/app_exceptions.dart';
import '../../../../core/config/logger.dart';
import '../../../../core/config/pref_keys.dart';
import '../../../../core/helper/api_response_helper.dart';
import '../../../../core/helper/api_url_helpers.dart';
import '../../../../core/helper/shared_preferences_helpers.dart';
import '../../../../core/values/string_values.dart';
import 'productListModel.dart';



class ProductsApiService {
  final http.Client _httpClient;
  final SharedPreferencesHelpers _sharedPrefKeys = SharedPreferencesHelpers();

  ProductsApiService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<ProductListModel> getProductsData(String query) async {
    final responseBody = await _getProductsData(query);

    try {
      //
      return ProductListModel.fromJson(responseBody);
      //
    } catch (exception, stackTrace) {
      //
      printLog(
        classFileName: 'ProductsApiService',
        logType: LoggerType.e,
        message: '$exception\n$stackTrace',
      );
      //await Sentry.captureException(exception, stackTrace: stackTrace);
      throw JsonDeserializationException(['$exception']);
    }
  }

  /// get Data Functions
  Future<dynamic> _getProductsData(String query) async {
    try {
      var token = await _sharedPrefKeys.getStringData(key: authTokenPrefKey);
      final response = await _httpClient.get(
        Uri.parse(vendorsProductsListApi+query),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization":"Bearer ${token ?? ""}"
        },
      );
      return apiResponseHelper(
        response: response,
        className: 'ProductsService',
        apiUrl: vendorsProductsListApi+query,
        requestValue: '',
        token: token ?? "",
      );
    } on SocketException {
      throw HttpException(StringValues.no_internet);
    } catch (exception) {
      //await Sentry.captureException(exception, stackTrace: stackTrace);
      throw HttpException('Error Communicating with Server');
    }
  }
}
