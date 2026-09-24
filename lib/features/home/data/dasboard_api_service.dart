import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../features/home/data/UserModel.dart';
import '../../../core/config/pref_keys.dart';
import '../../../core/helper/shared_preferences_helpers.dart';
import '../../../features/home/data/DashboarModel.dart';
import '../../../core/config/app_exceptions.dart';
import '../../../core/config/logger.dart';
import '../../../core/helper/api_response_helper.dart';
import '../../../core/helper/api_url_helpers.dart';
import '../../../core/values/string_values.dart';


class  DasboardApiService {
  final http.Client _httpClient;
  final SharedPreferencesHelpers _sharedPrefKeys = SharedPreferencesHelpers();
   DasboardApiService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<DashboarModel> getDashboardData() async {
    final responseBody = await _getDashboardData();

    try {
      //
      return DashboarModel.fromJson(responseBody);
      //
    } catch (exception, stackTrace) {
      //
      printLog(
        classFileName: 'DasboardApiService',
        logType: LoggerType.e,
        message: '$exception\n$stackTrace',
      );
      //await Sentry.captureException(exception, stackTrace: stackTrace);
      throw JsonDeserializationException(['$exception']);
    }
  }

  /// get Data Functions
  Future<dynamic> _getDashboardData() async {
    try {
      var token = await _sharedPrefKeys.getStringData(key: authTokenPrefKey);
      final response = await _httpClient.get(
        Uri.parse(dashboardApi),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization":"Bearer ${token ?? ""}"
        },
      );
      return apiResponseHelper(
        response: response,
        className: 'DashboarApiService',
        apiUrl: dashboardApi,
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

  Future<UserModel> getUserData() async {
    final responseBody = await _getUserData();

    try {
      return UserModel.fromJson(responseBody);
    } catch (exception, stackTrace) {
      printLog(
        classFileName: 'DasboardApiService',
        logType: LoggerType.e,
        message: '$exception\n$stackTrace',
      );
      throw JsonDeserializationException(['$exception']);
    }
  }

  /// get Data Functions
  Future<dynamic> _getUserData() async {
    try {
      var token = await _sharedPrefKeys.getStringData(key: authTokenPrefKey);
      final response = await _httpClient.get(
        Uri.parse(vendorDetailsApi),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization":"Bearer ${token ?? ""}"
        },
      );
      return apiResponseHelper(
        response: response,
        className: 'DashboarApiService',
        apiUrl: vendorDetailsApi,
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
