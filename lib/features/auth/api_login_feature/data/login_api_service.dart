import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/config/app_exceptions.dart';
import '../../../../core/config/extensions.dart';
import '../../../../core/config/logger.dart';
import '../../../../core/helper/api_response_helper.dart';
import '../../../../core/helper/api_url_helpers.dart';
import '../../../../core/utils/json_parser.dart';
import '../../../../core/values/string_values.dart';
import '../../../home/data/UserModel.dart';

class LoginApiService {
  final http.Client _httpClient;

  LoginApiService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  /// Exchanges the vendor's email and password for a customer token.
  Future<String> postUserLoginData({
    required Map<String, dynamic> requestValueMap,
  }) async {
    final responseBody = await _postData(
      requestValueMap: requestValueMap,
    );

    final token = JsonParser.toStr(responseBody);
    if (token == null || token.isEmpty) {
      throw JsonDeserializationException(['Login response has no token']);
    }
    return token;
  }

  /// Loads the vendor account behind [token]. Both login paths call this
  /// before storing the token, so a token the vendor API rejects is reported
  /// on the login screen instead of bouncing back from the dashboard.
  Future<UserModel> getVendor({required String token}) async {
    final http.Response response;
    try {
      response = await _httpClient.get(
        Uri.parse(vendorDetailsApi),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token"
        },
      );
    } on SocketException {
      throw HttpException(StringValues.no_internet);
    }

    'url:$vendorDetailsApi\nres:${response.statusCode}:${response.body}'.log();
    if (response.statusCode != 200) {
      throw VendorAccountException(
          response.statusCode, magentoErrorText(response.body));
    }

    try {
      return UserModel.fromJson(json.decode(response.body));
    } catch (exception, stackTrace) {
      printLog(
        classFileName: 'LoginApiService',
        logType: LoggerType.e,
        message: '$exception\n$stackTrace',
      );
      throw JsonDeserializationException(['$exception']);
    }
  }

  /// get Data Functions
  Future<dynamic> _postData({
    required Map<String, dynamic> requestValueMap,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse(userLoginApi),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(requestValueMap),
      );

      return apiResponseHelper(
        response: response,
        className: 'LoginApiService',
        apiUrl: userLoginApi,
        // Log the username only: the request map also carries the password.
        requestValue: '${requestValueMap['username']}',
        token: "",
      );
    } on SocketException {
      throw HttpException(StringValues.no_internet);
    } catch (exception) {
      //await Sentry.captureException(exception, stackTrace: stackTrace);
      throw HttpException('$exception');
    }
  }
}
