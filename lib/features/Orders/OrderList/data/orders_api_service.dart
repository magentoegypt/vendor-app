import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:multi_vendor/core/config/app_exceptions.dart';
import 'package:multi_vendor/core/config/logger.dart';
import 'package:multi_vendor/core/config/pref_keys.dart';
import 'package:multi_vendor/core/helper/api_response_helper.dart';
import 'package:multi_vendor/core/helper/api_url_helpers.dart';
import 'package:multi_vendor/core/helper/shared_preferences_helpers.dart';
import 'package:multi_vendor/core/values/string_values.dart';
import 'orderListModel.dart';


class OrdersApiService {
  final http.Client _httpClient;
  final SharedPreferencesHelpers _sharedPrefKeys = SharedPreferencesHelpers();

  OrdersApiService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<OrderListModel> getOrdersData({
    required String query,
  }) async {
    final responseBody = await _getOrdersData(query);

    try {
      //
      return OrderListModel.fromJson(responseBody);
      //
    } catch (exception, stackTrace) {
      //
      printLog(
        classFileName: 'OrdersApiService',
        logType: LoggerType.e,
        message: '$exception\n$stackTrace',
      );
      //await Sentry.captureException(exception, stackTrace: stackTrace);
      throw JsonDeserializationException(['$exception']);
    }
  }

  /// get Data Functions
  Future<dynamic> _getOrdersData(String query) async {
    try {
      var token = await _sharedPrefKeys.getStringData(key: authTokenPrefKey);
      final response = await _httpClient.get(
        Uri.parse(vendorsOrderListApi+query),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization":"Bearer ${token ?? ""}"
        },
      );

      //
      return apiResponseHelper(
        response: response,
        className: 'OrdersApiService',
        apiUrl: vendorsOrderListApi+query,
        requestValue: '',
        token: token ?? '',
      );
      //

    } on SocketException {
      //
      throw HttpException(StringValues.no_internet);
      //
    } catch (exception) {
      //
      //await Sentry.captureException(exception, stackTrace: stackTrace);

      throw HttpException('Error Communicating with Server');
      //

    }
  }
}
