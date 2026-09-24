import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/config/app_constants.dart';
import '../../../../features/auth/register_feature/data/CountryListModel.dart';
import '../../../../core/config/app_exceptions.dart';
import '../../../../core/config/logger.dart';
import '../../../../core/helper/api_response_helper.dart';
import '../../../../core/helper/api_url_helpers.dart';
import '../../../../core/values/string_values.dart';
import 'SignUpModel.dart';

class RegisterApiService {
  final http.Client _httpClient;

  RegisterApiService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<SignUpModel> postUserRegisterData({
    required Map<String, dynamic> requestValueMap,
  }) async {
    final responseBody = await _postData(
      requestValueMap: requestValueMap,
    );

    try {
      return SignUpModel.fromJson(responseBody);
    } catch (exception, stackTrace) {
      //
      printLog(
        classFileName: 'RegisterApiService',
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
        Uri.parse(userRegisterApi),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization":"Bearer $AdminKey"
        },
        body: json.encode(requestValueMap),
      );
      return apiResponseHelper(
        response: response,
        className: 'RegisterApiService',
        apiUrl: userRegisterApi,
        requestValue: '$requestValueMap',
        token: '',
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
        classFileName: 'RegisterApiService',
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
        className: 'RegisterApiService',
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

}
