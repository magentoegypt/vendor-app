import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:multi_vendor/features/home/data/UserModel.dart';
import '../../../../core/config/app_exceptions.dart';
import '../../../../core/config/logger.dart';
import '../../../../core/helper/api_response_helper.dart';
import '../../../../core/helper/api_url_helpers.dart';
import '../../../../core/values/string_values.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/helper/shared_preferences_helpers.dart';
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
    final responseBody = await _postData(
      requestValueMap: requestValueMap,
    );
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

  /// get Data Functions
  Future<dynamic> _postData({
    required Map<String, dynamic> requestValueMap,
  }) async {

    try {
      final response = await _httpClient.post(
        Uri.parse(vendorUpdateDataApi),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization":"Bearer $AdminKey"
        },
        body: json.encode(requestValueMap),
      );
      return apiResponseHelper(
        response: response,
        className: 'ProfileApiService',
        apiUrl: vendorUpdateDataApi,
        requestValue: '$requestValueMap',
        token: AdminKey,
      );
    } on SocketException {
      throw HttpException(StringValues.no_internet);
    } catch (exception, stackTrace) {
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

  Future<bool> deleteVendorData(String vendorId) async {
    final responseBody = await _deleteVendorData(vendorId);
    try {
      return responseBody;
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
  Future<dynamic> _deleteVendorData(String vendorId) async {
    try {
      final response = await _httpClient.delete(
        Uri.parse(vendorDeleteDataApi+vendorId),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization":"Bearer $AdminKey"
        },
      );
      return apiResponseHelper(
        response: response,
        className: 'ProfileApiService',
        apiUrl: vendorDeleteDataApi+vendorId,
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

}
