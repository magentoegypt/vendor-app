import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/config/app_exceptions.dart';
import '../../../../core/config/logger.dart';
import '../../../../core/helper/api_response_helper.dart';
import '../../../../core/helper/api_url_helpers.dart';
import '../../../../core/values/string_values.dart';
import 'productListModel.dart';
import 'package:multi_vendor/core/helper/session_token.dart';



class ProductsApiService {
  final http.Client _httpClient;

  /// The wait before the one retry of a failed list request.
  final Duration retryPause;

  ProductsApiService(
      {http.Client? httpClient,
      this.retryPause = const Duration(milliseconds: 1500)})
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

  /// Asks a second time when the first try fails in a way that may pass: no
  /// connection, a server or gateway error (5xx), or a reply that is not
  /// JSON. QA saw the list fail on the first open and load on the second.
  Future<dynamic> _getProductsData(String query) async {
    for (var attempt = 1;; attempt++) {
      final last = attempt == 2;
      try {
        var token = await SessionToken.current();
        final response = await _httpClient.get(
          Uri.parse(vendorsProductsListApi+query),
          headers: <String, String>{
            'Content-Type': 'application/json',
            "Authorization":"Bearer ${token ?? ""}"
          },
        );
        if (response.statusCode >= 500 && !last) {
          await Future<void>.delayed(retryPause);
          continue;
        }
        return await apiResponseHelper(
          response: response,
          className: 'ProductsService',
          apiUrl: vendorsProductsListApi+query,
          requestValue: '',
          token: token ?? "",
        );
      } on HttpException {
        // The server's own message, e.g. the 403 for a pending or disabled
        // seller account: show it, not a generic network error.
        rethrow;
      } on SessionExpiredException {
        rethrow;
      } catch (exception) {
        if (!last) {
          await Future<void>.delayed(retryPause);
          continue;
        }
        //await Sentry.captureException(exception, stackTrace: stackTrace);
        throw HttpException(exception is SocketException
            ? StringValues.no_internet
            : StringValues.server_error);
      }
    }
  }
}
