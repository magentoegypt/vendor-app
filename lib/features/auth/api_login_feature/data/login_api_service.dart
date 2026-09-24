import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:multi_vendor/core/config/app_constants.dart';
import 'package:multi_vendor/core/config/locator.dart';
import '../../../../core/config/app_exceptions.dart';
import '../../../../core/config/logger.dart';
import '../../../../core/helper/api_response_helper.dart';
import '../../../../core/helper/api_url_helpers.dart';
import '../../../../core/values/string_values.dart';
import '../../../../main.dart';

class LoginApiService {
  final http.Client _httpClient;

  LoginApiService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<String> postUserLoginData({
    required Map<String, dynamic> requestValueMap,
  }) async {
    final responseBody = await _postData(
      requestValueMap: requestValueMap,
    );

    try {
      //
      return responseBody;
      //
    } catch (exception, stackTrace) {
      //
      printLog(
        classFileName: 'LoginApiService',
        logType: LoggerType.e,
        message: '$exception\n$stackTrace',
      );

      //
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
        Uri.parse(userLoginApi),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(requestValueMap),
      );

      if(response.statusCode == 200) {
        final lognresponse = await _httpClient.get(
          Uri.parse(vendorDetailsApi),
          headers: <String, String>{
            'Content-Type': 'application/json',
            "Authorization": "Bearer ${json.decode(response.body) ?? ""}"
          },
        );
        if(lognresponse.statusCode != 200){
          if(selectedLanguage == "ar"){
            throw HttpException('البريد الإلكتروني أو كلمة المرور غير صحيحة');
          }else{
            throw HttpException('Incorrect email or password');
          }
        }else{
          return apiResponseHelper(
            response: response,
            className: 'LoginApiService',
            apiUrl: userLoginApi,
            requestValue: '$requestValueMap',
            token: "",
          );
        }
      }

      //
      return apiResponseHelper(
        response: response,
        className: 'LoginApiService',
        apiUrl: userLoginApi,
        requestValue: '$requestValueMap',
        token: "",
      );
      //
    } on SocketException {
      //
      throw HttpException(StringValues.no_internet);
      //
    } catch (exception) {
      //
      //await Sentry.captureException(exception, stackTrace: stackTrace);

      throw HttpException('$exception');
      //

    }
  }
}
