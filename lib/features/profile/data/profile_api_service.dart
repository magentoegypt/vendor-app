import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:multi_vendor/features/home/data/UserModel.dart';
import '../../../../core/config/app_exceptions.dart';
import '../../../../core/config/logger.dart';
import '../../../../core/helper/api_response_helper.dart';
import '../../../../core/helper/api_url_helpers.dart';
import '../../../../core/values/string_values.dart';
import '../../../core/config/pref_keys.dart';
import '../../../core/helper/shared_preferences_helpers.dart';
import '../../auth/api_login_feature/data/login_api_service.dart';
import '../../auth/register_feature/data/CountryListModel.dart';
import '../../auth/register_feature/data/SignUpModel.dart';

class ProfileApiService {
  final http.Client _httpClient;
  final SharedPreferencesHelpers _sharedPrefKeys = SharedPreferencesHelpers();
  ProfileApiService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<UserModel> postUserProfileData({
    required Map<String, dynamic> requestValueMap,
  }) async {
    final token = await _sharedPrefKeys.getStringData(key: authTokenPrefKey) ?? "";
    final responseBody = await _putData(
      requestValueMap: requestValueMap,
      token: token,
    );
    // PUT /V1/vendors/me may answer with the saved vendor or just true; in the
    // second case read the profile back so the stored copy matches the server.
    if (responseBody is! Map<String, dynamic>) {
      return LoginApiService(httpClient: _httpClient).getVendor(token: token);
    }
    try {
      return UserModel.fromJson(responseBody);
    } catch (exception, stackTrace) {
      //
      printLog(
        classFileName: 'ProfileApiService',
        logType: LoggerType.e,
        message: '$exception\n$stackTrace',
      );
      //await Sentry.captureException(exception, stackTrace: stackTrace);
      throw JsonDeserializationException(['$exception']);
    }
  }

  /// Updates the signed-in vendor with their own token. The server only
  /// changes profile fields; id, status and email in the body are ignored.
  Future<dynamic> _putData({
    required Map<String, dynamic> requestValueMap,
    required String token,
  }) async {

    try {
      final response = await _httpClient.put(
        Uri.parse(vendorUpdateDataApi),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization":"Bearer $token"
        },
        body: json.encode(requestValueMap),
      );
      return apiResponseHelper(
        response: response,
        className: 'ProfileApiService',
        apiUrl: vendorUpdateDataApi,
        requestValue: '$requestValueMap',
        token: token,
      );
    } on SocketException {
      throw HttpException(StringValues.no_internet);
    } on AppException {
      // Keep the server's message (e.g. a validation error) for the vendor.
      rethrow;
    } catch (exception) {
      throw HttpException('Error Communicating with Server');
    }
  }

  Future<List<CountryListModel>> getCountriesData() async {
    final responseBody = await getCountries();
    try {
      List<CountryListModel> list = [];
      responseBody.forEach((v) {
        list.add(CountryListModel.fromJson(v));
      });
      return list;
    } catch (exception, stackTrace) {
      //
      printLog(
        classFileName: 'ProfileApiService',
        logType: LoggerType.e,
        message: '$exception\n$stackTrace',
      );
      //await Sentry.captureException(exception, stackTrace: stackTrace);
      throw JsonDeserializationException(['$exception']);
    }
  }
  /// get Data Functions
  Future<dynamic> getCountries() async {
    try {
      final response = await _httpClient.get(
        Uri.parse(countryInformationAcquirerApi),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      return apiResponseHelper(
        response: response,
        className: 'ProfileApiService',
        apiUrl: countryInformationAcquirerApi,
        requestValue: '',
        token: '',
      );
      //
    } on SocketException {
      throw HttpException(StringValues.no_internet);
    } catch (exception, stackTrace) {
      throw HttpException('Error Communicating with Server');
    }
  }

  /// Deletes the signed-in vendor's own account.
  Future<bool> deleteVendorData() async {
    final responseBody = await _deleteVendorData();
    // The endpoint answers true; any other 2xx body also means it was deleted.
    return responseBody is bool ? responseBody : true;
  }
  /// get Data Functions
  Future<dynamic> _deleteVendorData() async {
    try {
      final token = await _sharedPrefKeys.getStringData(key: authTokenPrefKey) ?? "";
      final response = await _httpClient.delete(
        Uri.parse(vendorDeleteDataApi),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization":"Bearer $token"
        },
      );
      return apiResponseHelper(
        response: response,
        className: 'ProfileApiService',
        apiUrl: vendorDeleteDataApi,
        requestValue: '',
        token: token,
      );
      //
    } on SocketException {
      throw HttpException(StringValues.no_internet);
    } on AppException {
      rethrow;
    } catch (exception) {
      throw HttpException('Error Communicating with Server');
    }
  }

}
